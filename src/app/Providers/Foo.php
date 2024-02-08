<?php

declare(strict_types=1);

namespace App\Providers;

final class Foo
{
    public static function dump(): string
    {
        $date = date('d-M-Y H:i:s');
        $line = 'Executed method [ ' . __FUNCTION__ . ' ] in [ ' . getenv('ENV') . ' ] mode' . PHP_EOL;

        return sprintf('[%s] %s: %s', $date, self::class, $line);
    }
}
