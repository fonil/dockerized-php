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
     * @covers \App\Providers\Foo::log
     *
     * @dataProvider dataProviderForInvoke
     */
    public function testInvoke(string $expectedResult, string $expectedLog): void
    {
        $result = (new Foo)();

        $this->assertEquals($expectedResult, $result);
        $this->assertStringContainsString($expectedLog, file_get_contents($_ENV['APP_LOG_STREAM']));
    }

    public function dataProviderForInvoke(): array
    {
        return [
            [
                Foo::class,
                '[01-Jan-2023 00:00:00] App\Providers\Foo: Executed method __invoke',
            ],
        ];
    }
}
