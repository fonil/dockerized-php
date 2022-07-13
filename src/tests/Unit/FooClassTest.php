<?php

namespace UnitTests;

use App\Foo\FooClass;
use PHPUnit\Framework\TestCase;

/**
 * @internal
 *
 * @coversNothing
 */
final class FooClassTest extends TestCase
{
    /**
     * @covers \App\Foo\FooClass::__invoke
     *
     * @dataProvider dataProviderHappyPath
     */
    public function testHappyPath(string $expectedOutput): void
    {
        $output = (new FooClass())();

        static::assertSame($expectedOutput, $output);
    }

    /**
     * @return array<int, array<int, string>>
     */
    public function dataProviderHappyPath(): array
    {
        return [
            ['App\Foo\FooClass::__invoke'],
        ];
    }
}
