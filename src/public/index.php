<?php

declare(strict_types=1);

require_once dirname(__DIR__) . '/vendor/autoload.php';

use App\Debug\Buggregator;
use App\Providers\Foo;

Buggregator::setup();

Buggregator::startProfiler();

dump([__FILE__, __LINE__]);

Buggregator::debug('Monolog debug entry');
Buggregator::info('Monolog info entry');
Buggregator::notice('Monolog notice entry');
Buggregator::warning('Monolog warning entry');
Buggregator::error('Monolog error entry');
Buggregator::critical('Monolog critical entry');
Buggregator::alert('Monolog alert entry');
Buggregator::emergency('Monolog emergency entry');

try {
    throw new \Exception('Exception sent to Sentry');
} catch (\Throwable $exception) {
    \Sentry\captureException($exception);
}

echo (new Foo())();

Buggregator::endProfiler();
