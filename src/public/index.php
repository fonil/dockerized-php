<?php

declare(strict_types=1);

require_once __DIR__ . '/../vendor/autoload.php';

use App\Providers\Foo;

echo sprintf('Class [ %s ] %s', (new Foo())(), PHP_EOL);
