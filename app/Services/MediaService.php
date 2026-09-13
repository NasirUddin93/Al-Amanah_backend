<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use InvalidArgumentException;

/**
 * Centralized image/media handling.
 *
 * Storage contract:
 *  - The database stores RELATIVE paths, never absolute URLs.
 *  - Receipt files (public disk): value looks like "receipts/2026/09/file.webp".
 *  - ID photo files (id_photos disk): value is the plain filename "id_xxx.png".
 *  - Full URLs are generated at serialization time via url().
 */
class MediaService
{
    /**
     * Maximum decoded byte size accepted for base64 uploads (5 MB).
     *
     * Kept in sync with the frontend MAX_ID_PHOTO_BYTES limit so requests stay
     * comfortably below the PHP post_max_size default (8 MB) after the ~33%
     * base64 encoding overhead.
     */
    public const MAX_BASE64_BYTES = 5 * 1024 * 1024;

    /**
     * Generate the public URL for a stored relative path.
     *
     * @param  string|null  $path  Relative path stored in the DB.
     * @param  string  $disk  'public' or 'id_photos'.
     */
    public function url(?string $path, string $disk = 'public'): ?string
    {
        if (empty($path) || $path === '/') {
            return null;
        }

        // Paths that are already full URLs / data URLs are returned untouched.
        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://') || str_starts_with($path, 'data:')) {
            return $path;
        }

        if ($disk === 'id_photos') {
            return url('api/id-photos/' . basename($path));
        }

        return Storage::disk('public')->url(ltrim($path, '/'));
    }

    /**
     * Store a raw binary image payload under a subdirectory of the public disk.
     *
     * Returns the relative path (e.g. "receipts/2026/09/file.webp").
     */
    public function storeBinary(string $binary, string $subdirectory, string $extension = 'jpg'): string
    {
        $fallbackExt = in_array(strtolower($extension), ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'])
            ? strtolower($extension)
            : 'png';

        $folder = trim($subdirectory, '/');
        $fileName = $this->uniqueFileName($folder, $fallbackExt);

        Storage::disk('public')->put($fileName, $binary);

        return $fileName;
    }

    /**
     * Store an uploaded file under a subdirectory of the public disk.
     *
     * Returns the relative path.
     */
    public function storeUploadedFile(UploadedFile $file, string $subdirectory): string
    {
        $folder = trim($subdirectory, '/');
        $fileName = $this->uniqueFileName($folder, $file->guessExtension() ?: 'jpg');

        Storage::disk('public')->put($fileName, file_get_contents($file->getRealPath()));

        return $fileName;
    }

    /**
     * Store raw binary data on the private id_photos disk.
     *
     * Returns the plain filename (relative to the id_photos disk root).
     */
    public function storeIdPhoto(string $binary, string $extension = 'png'): string
    {
        $ext = in_array(strtolower($extension), ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp']) ? strtolower($extension) : 'png';
        $fileName = 'id_' . time() . '_' . uniqid() . '.' . $ext;

        Storage::disk('id_photos')->put($fileName, $binary);

        return $fileName;
    }

    /**
     * Delete a stored file. Accepts a relative path on the given disk.
     */
    public function delete(?string $path, string $disk = 'public'): bool
    {
        if (empty($path)) {
            return false;
        }

        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://') || str_starts_with($path, 'data:')) {
            // Does not belong to our storage; safely ignore.
            return false;
        }

        if ($disk === 'public') {
            return Storage::disk('public')->delete(ltrim($path, '/'));
        }

        return Storage::disk('id_photos')->delete(basename($path));
    }

    /**
     * Decode the raw bytes from a base64 data URL.
     *
     * @throws InvalidArgumentException  When the payload exceeds MAX_BASE64_BYTES.
     */
    public function decodeBase64(string $dataUrl): string
    {
        $raw = substr($dataUrl, strpos($dataUrl, ',') + 1);
        $decoded = base64_decode($raw);

        if ($decoded === false) {
            throw new InvalidArgumentException('Invalid base64 image payload.');
        }

        if (strlen($decoded) > self::MAX_BASE64_BYTES) {
            throw new InvalidArgumentException('Image payload exceeds the maximum allowed size of 5 MB.');
        }

        return $decoded;
    }

    /**
     * Extract the file extension from a base64 data URL.
     */
    public function extractExtension(string $dataUrl): string
    {
        if (preg_match('/^data:image\/(\w+);base64,/', $dataUrl, $matches)) {
            return strtolower($matches[1]);
        }

        return 'png';
    }

    /**
     * Whether a payload looks like a base64 data URL.
     */
    public function isBase64DataUrl(mixed $value): bool
    {
        return is_string($value) && (bool) preg_match('/^data:image\/[\w.+-]+;base64,/', $value);
    }

    /**
     * Reduce a stored or legacy value to a relative path for the DB.
     *
     * Accepts:
     *  - a full URL ending in /storage/<path>           -> <path>
     *  - a /storage/<path> string                        -> <path>
     *  - an /api/id-photos/<file> URL                    -> <file>
     *  - an already-relative path                        -> untouched
     */
    public function normalizePath(mixed $value): ?string
    {
        if (!is_string($value) || trim($value) === '') {
            return null;
        }

        $value = trim($value);

        // Already relative.
        if (!str_starts_with($value, 'http://') && !str_starts_with($value, 'https://') && !str_starts_with($value, '/')) {
            return $value;
        }

        // /api/id-photos/<file> endpoints.
        if (preg_match('#/(?:api/)?id-photos/([^/?]+)#', $value, $m)) {
            return basename($m[1]);
        }

        // /storage/<path>
        if (preg_match('#/storage/([^?]+)#', $value, $m)) {
            $path = ltrim($m[1], '/');

            // Legacy public copy of id photos => private disk filename only.
            if (preg_match('#^id_photos/([^/]+)$#i', $path, $fm)) {
                return basename($fm[1]);
            }

            return $path;
        }

        // Relative /some/path -> strip leading slash
        return ltrim($value, '/');
    }

    /**
     * Generate a unique file name inside a folder, ensuring the file does not exist yet.
     */
    protected function uniqueFileName(string $folder, string $extension): string
    {
        $ext = ltrim(strtolower($extension), '.');
        if ($ext === '') {
            $ext = 'jpg';
        }

        do {
            $fileName = $folder . '/' . date('Y/m') . '/' . uniqid('', true) . '.' . $ext;
        } while (Storage::disk('public')->exists($fileName));

        return $fileName;
    }
}