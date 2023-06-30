<?php

declare(strict_types=1);

namespace App\Providers;

final class Foo
{
    public function __invoke(): string
    {
        return self::class;
    }
}
