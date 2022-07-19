<?php

declare(strict_types=1);

namespace App\Foo;

final class FooClass
{
    public function __invoke(): string
    {
        return __METHOD__;
    }
}
