<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * Normalize stored image references from absolute URLs to relative paths.
 *
 * BEFORE: transactions.receipt_photo = "http://localhost:8000/storage/receipts/....jpeg"
 *   user_profiles.id_photo       = ["http://localhost:8000/storage/id_photos/id_....png", ...]
 *
 * AFTER:  transactions.receipt_photo = "receipts/receipt_....jpeg"
 *   user_profiles.id_photo       = ["id_....png", ...]
 *
 * Relative paths are resilient to domain / protocol changes; URLs are
 * generated at serialization time from the current APP_URL.
 */
return new class extends Migration
{
    public function up(): void
    {
        $this->normalizeReceiptPhotos();
        $this->normalizeIdPhotos();
    }

    protected function normalizeReceiptPhotos(): void
    {
        $rows = DB::table('transactions')
            ->whereNotNull('receipt_photo')
            ->where('receipt_photo', '!=', '')
            ->get(['id', 'receipt_photo']);

        foreach ($rows as $row) {
            $relative = $this->toRelativePath($row->receipt_photo);

            if ($relative !== null && $relative !== $row->receipt_photo) {
                DB::table('transactions')->where('id', $row->id)->update(['receipt_photo' => $relative]);
            }
        }
    }

    protected function normalizeIdPhotos(): void
    {
        $rows = DB::table('user_profiles')
            ->whereNotNull('id_photo')
            ->where('id_photo', '!=', '')
            ->get(['id', 'id_photo']);

        foreach ($rows as $row) {
            $decoded = json_decode($row->id_photo, true);

            if (!is_array($decoded)) {
                $items = [$row->id_photo];
            } else {
                $items = $decoded;
            }

            $normalized = [];
            foreach ($items as $item) {
                if (!is_string($item) || trim($item) === '') {
                    continue;
                }

                $relative = $this->toRelativePath(trim($item));
                if ($relative !== null) {
                    $normalized[] = $relative;
                }
            }

            if (empty($normalized)) {
                continue;
            }

            $newValue = json_encode(array_values($normalized));

            if ($newValue !== $row->id_photo) {
                DB::table('user_profiles')->where('id', $row->id)->update(['id_photo' => $newValue]);
            }
        }
    }

    /**
     * Convert an absolute URL / storage path to a relative path.
     *
     *   http://host/storage/receipts/x.jpeg  -> receipts/x.jpeg
     *   http://host/storage/id_photos/y.png  -> y.png   (id_photos disk filename)
     *   http://host/api/id-photos/y.png      -> y.png
     *   /storage/receipts/x.jpeg             -> receipts/x.jpeg
     *   receipts/x.jpeg                      -> receipts/x.jpeg (already relative)
     */
    protected function toRelativePath(string $value): ?string
    {
        $value = trim($value);

        if ($value === '') {
            return null;
        }

        // Already relative (not a URL and not starting with a slash).
        if (!preg_match('#^https?://#i', $value) && !str_starts_with($value, '/')) {
            return $value;
        }

        // API endpoint for private id photos.
        if (preg_match('#/(?:api/)?id-photos/([^/?]+)#i', $value, $m)) {
            return basename($m[1]);
        }

        // Public storage path.
        if (preg_match('#/storage/([^?]+)#i', $value, $m)) {
            $path = ltrim($m[1], '/');

            // Legacy public copy of id photos => private disk filename only.
            if (preg_match('#^id_photos/([^/]+)$#i', $path, $fm)) {
                return basename($fm[1]);
            }

            return $path;
        }

        return null;
    }

    public function down(): void
    {
        // Path normalization is not reversible; leaving the up() transformation.
    }
};