<?php

declare(strict_types=1);

namespace Hooks;

use DG\BypassFinals;
use PHPUnit\Runner\BeforeTestHook;

/**
 * PHPUnit Hook that allows to mock final classes in PHP
 *
 * @author  David Grudl <david@grudl.com>
 * @license https://github.com/dg/bypass-finals/blob/master/license.md
 * @link    https://tomasvotruba.com/blog/2019/03/28/how-to-mock-final-classes-in-phpunit
 */
final class BypassFinalHook implements BeforeTestHook
{
    public function executeBeforeTest(string $test): void
    {
        BypassFinals::enable();
    }
}
