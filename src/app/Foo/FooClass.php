<?php

namespace App\Foo;

final class FooClass
{
    public function __invoke(): string
    {
        return __METHOD__;
    }
}
