<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class CleanOrphanedMedia extends Command
{
    protected $signature = 'media:clean {--dry-run : Report files without deleting them}';

    protected $description = 'Delete receipt and ID photo files no longer referenced in the database';

    public function handle(): int
    {
        $dryRun = (bool) $this->option('dry-run');

        $deleted = $this->cleanPublicDisk($dryRun);
        $deleted += $this->cleanIdPhotosDisk($dryRun);

        $this->info($dryRun
            ? "Dry run complete. {$deleted} orphaned file(s) would be deleted."
            : "Cleanup complete. Deleted {$deleted} orphaned file(s).");

        return self::SUCCESS;
    }

    private function cleanPublicDisk(bool $dryRun): int
    {
        $referenced = DB::table('transactions')
            ->whereNotNull('receipt_photo')
            ->select('receipt_photo')
            ->pluck('receipt_photo');

        $referencedThumbs = DB::table('transactions')
            ->whereNotNull('receipt_photo_thumbnail')
            ->select('receipt_photo_thumbnail')
            ->pluck('receipt_photo_thumbnail');

        $referenced = $referenced->merge($referencedThumbs)->map(fn ($v) => $this->normalize($v))->flip();

        $disk = Storage::disk('public');
        $files = $disk->allFiles('receipts');

        return $this->cleanFiles($disk, $files, $referenced, $dryRun, 'public/receipts');
    }

    private function cleanIdPhotosDisk(bool $dryRun): int
    {
        $rows = DB::table('user_profiles')
            ->whereNotNull('id_photo')
            ->where('id_photo', '!=', '')
            ->pluck('id_photo');

        $referenced = collect();

        foreach ($rows as $value) {
            $decoded = json_decode($value, true);

            if (is_array($decoded)) {
                foreach ($decoded as $item) {
                    if (is_string($item) && trim($item) !== '') {
                        $referenced->push(trim($item));
                    }
                }
            } elseif ($value !== '') {
                $referenced->push($value);
            }
        }

        $referenced = $referenced->map(fn ($v) => basename($this->normalize($v)))->flip();

        $disk = Storage::disk('id_photos');
        $files = $disk->allFiles();

        return $this->cleanFiles($disk, $files, $referenced, $dryRun, 'id_photos');
    }

    private function cleanFiles($disk, array $files, $referenced, bool $dryRun, string $label): int
    {
        $deleted = 0;

        foreach ($files as $file) {
            $key = $label === 'id_photos' ? basename($file) : $file;

            if ($referenced->has($key)) {
                continue;
            }

            $deleted++;

            if ($dryRun) {
                $this->line("  [orphan] {$label}/{$file}");
            } elseif ($disk->delete($file)) {
                $this->line("  [deleted] {$label}/{$file}");
            }
        }

        return $deleted;
    }

    private function normalize(string $value): string
    {
        $value = trim($value);

        if (str_contains($value, 'storage/id_photos/') || str_contains($value, '/api/id-photos/')) {
            return basename($value);
        }

        if (str_starts_with($value, '/storage/')) {
            return ltrim(substr($value, strlen('/storage/')), '/');
        }

        if (preg_match('#^https?://#i', $value)) {
            $path = parse_url($value, PHP_URL_PATH);
            $value = $path !== null ? $path : $value;
            $value = ltrim($value, '/');
            $value = str_replace('storage/', '', $value, $count);
        }

        return $value;
    }
}