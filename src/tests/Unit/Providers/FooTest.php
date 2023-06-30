<?php

declare(strict_types=1);

namespace UnitTests\Providers;

use App\Providers\Foo;
use PHPUnit\Framework\TestCase;

/**
 * @internal
 *
 * @coversNothing
 */
final class FooTest extends TestCase
{
    /**
     * @covers \App\Providers\Foo::__invoke
     */
    public function testInvoke(): void
    {
        $result = (new Foo)();

        $this->assertEquals('App\Providers\Foo', $result);
    }
}
