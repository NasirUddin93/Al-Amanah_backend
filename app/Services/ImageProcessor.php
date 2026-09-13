<?php

namespace App\Services;

use Illuminate\Support\Facades\Storage;
use Intervention\Image\Drivers\Gd\Driver;
use Intervention\Image\ImageManager;
use RuntimeException;

/**
 * Server-side image processing: resize, thumbnail generation and WebP conversion.
 */
class ImageProcessor
{
    /**
     * Documents (ID photos) are kept at a higher resolution and in their
     * original format so identity documents remain legible.
     */
    public const DOC_MAX_WIDTH = 1600;

    /**
     * Receipt photos are resized to this max width and stored as WebP.
     */
    public const RECEIPT_MAX_WIDTH = 2000;
    public const RECEIPT_QUALITY = 85;

    public const THUMBNAIL_WIDTH = 300;
    public const THUMBNAIL_QUALITY = 60;

    protected ?ImageManager $manager = null;

    /**
     * Process receipt photo binary data:
     *  - strips EXIF / orients image
     *  - resizes to a maximum width
     *  - stores the full-sized WebP on the public disk
     *  - generates and stores a small WebP thumbnail
     *
     * @return array{path: string, thumbnail: string}  relative paths on the public disk
     */
    public function processReceipt(string $binary): array
    {
        $manager = $this->manager();

        $image = $manager->decode($binary);
        $image->orient();
        $image->scaleDown(self::RECEIPT_MAX_WIDTH);

        $folder = trim('receipts', '/');
        $base = $folder . '/' . date('Y/m') . '/' . uniqid('receipt_', true);

        $fullPath = $base . '.webp';
        $thumbPath = $base . '_thumb.webp';

        $storage = Storage::disk('public');

        // Stream the encoded image directly to storage.
        $storage->put($fullPath, $image->encodeUsingFileExtension('webp', self::RECEIPT_QUALITY)->toString());

        $image->scaleDown(self::THUMBNAIL_WIDTH);
        $storage->put($thumbPath, $image->encodeUsingFileExtension('webp', self::THUMBNAIL_QUALITY)->toString());

        return [
            'path'      => $fullPath,
            'thumbnail' => $thumbPath,
        ];
    }

    /**
     * Process an ID document photo:
     *  - orients / strips EXIF
     *  - resizes down to a maximum width
     *  - stores in its original format on the private id_photos disk
     *
     * @return string  plain filename (relative to the id_photos disk)
     */
    public function processIdPhoto(string $binary): ?string
    {
        $manager = $this->manager();

        try {
            $image = $manager->decode($binary);
        } catch (\Throwable) {
            return null;
        }

        $image->orient();
        $image->scaleDown(self::DOC_MAX_WIDTH);

        $fileName = 'id_' . time() . '_' . uniqid() . '.' . $this->extensionOf($image->origin()->mediaType() ?? '');

        $encoded = $image->encodeUsingFileExtension($this->extensionOf($image->origin()->mediaType() ?? 'png'), 90);
        Storage::disk('id_photos')->put($fileName, $encoded->toString());

        return $fileName;
    }

    protected function extensionOf(string $mediaType): string
    {
        $map = [
            'image/jpeg' => 'jpg',
            'image/png'  => 'png',
            'image/webp' => 'webp',
            'image/gif'  => 'gif',
            'image/bmp'  => 'bmp',
        ];

        return $map[strtolower($mediaType)] ?? 'png';
    }

    protected function manager(): ImageManager
    {
        if ($this->manager === null) {
            $this->manager = new ImageManager(Driver::class);
        }

        return $this->manager;
    }
}