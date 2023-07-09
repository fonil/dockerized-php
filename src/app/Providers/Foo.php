<?php

declare(strict_types=1);

namespace App\Providers;

final class Foo
{
    public function __invoke(): string
    {
        $this->log(__CLASS__, 'Executed method '. __FUNCTION__);

        return self::class;
    }

    protected function log(string $className, string $line): void
    {
        file_put_contents($_ENV['APP_LOG_STREAM'], sprintf(
            '[%s] %s: %s%s',
            date('d-M-Y H:i:s'),
            $className,
            $line,
            PHP_EOL
        ));
    }
}
