<?php

declare(strict_types=1);

require_once dirname(__DIR__) . '/vendor/autoload.php';

use App\Providers\Foo;

// Run the app
echo Foo::dump();

// Check file permissions
file_put_contents('/output/foo.txt', Foo::dump());
