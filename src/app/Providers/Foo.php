<?php

declare(strict_types=1);

namespace App\Providers;

final class Foo
{
    public function __invoke(): string
    {
        $date = date('d-M-Y H:i:s');
        $line = 'Executed method ' . __FUNCTION__ . PHP_EOL;

        return sprintf('[%s] %s: %s', $date, self::class, $line);
    }
}
