<?php

declare(strict_types=1);

require_once __DIR__ . '/../vendor/autoload.php';

use App\Providers\Foo;

// Load .env

$env = parse_ini_file(__DIR__ . '/../.env');

foreach ($env as $key => $value) {
	$_ENV[$key] = $value;
}

// Process

echo sprintf('Class [ %s ] %s', (new Foo())(), PHP_EOL);
