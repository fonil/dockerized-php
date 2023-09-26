<?php

declare(strict_types=1);

namespace UnitTests\Providers;

use App\Providers\Foo;
use PHPUnit\Framework\TestCase;
use SlopeIt\ClockMock\ClockMock;

/**
 * @internal
 *
 * @coversNothing
 *
 * @phpstan-type DataProviderEntry array{string, string}
 */
final class FooTest extends TestCase
{
    protected function setUp(): void
    {
        ClockMock::freeze(new \DateTime('2023-01-01 00:00:00'));
    }

    protected function tearDown(): void
    {
        ClockMock::reset();
    }

    /**
     * @covers \App\Providers\Foo::__invoke
     *
     * @dataProvider dataProviderForInvoke
     */
    public function testInvoke(string $expectedClass, string $expectedLog): void
    {
        $instance = new Foo();

        $log = $instance->__invoke();

        $this->assertEquals($expectedClass, $instance::class);
        $this->assertEquals($expectedLog, $log);
    }

    /**
     * @covers \App\Providers\Foo::__invoke
     */
    public function testMock(): void
    {
        $finalClassMock = $this->createMock(Foo::class);

        $this->assertArrayHasKey('PHPUnit\Framework\MockObject\MockObject', class_implements($finalClassMock));
    }

    /**
     * @return array<int, DataProviderEntry>
     */
    public static function dataProviderForInvoke(): array
    {
        return [
            [
                Foo::class,
                '[01-Jan-2023 00:00:00] App\Providers\Foo: Executed method __invoke' . PHP_EOL,
            ],
        ];
    }
}
