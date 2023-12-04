<?php

declare(strict_types=1);

namespace App\Debug;

use Monolog\Logger;
use Monolog\Handler\SocketHandler;
use Monolog\Formatter\JsonFormatter;
use Xhgui\Profiler\Profiler;

final class Buggregator
{
    private const CONFIG = [
        'PROFILER_APP_NAME' => 'Demo Application',
        'PROFILER_ENDPOINT' => 'http://profiler@buggregator:8000',
        'VAR_DUMPER_FORMAT' => 'server',
        'VAR_DUMPER_SERVER' => 'buggregator:9912',
        'SENTRY_DSN' => 'http://sentry@buggregator:8000/1',
        'SMTP_MAILER_DSN' => 'smtp://127.0.0.1:1025',
        'MONOLOG_DEFAULT_CHANNEL' => 'socket',
        'MONOLOG_SOCKET_HOST' => 'buggregator:9913',
    ];

    private static Logger $log;
    private static Profiler $profiler;

    public static function setup(): void
    {
        // Populate into ENV/SERVER variables

        array_map(function ($key, $value) {
            $_SERVER[$key] = $value;
        }, array_keys(self::CONFIG), array_values(self::CONFIG));

        // Setup dependencies

        \Sentry\init([
            'dsn' => $_SERVER['SENTRY_DSN'],
        ]);
    }

    // Monolog

    /** @param array<string> $context */
    public static function debug(string $message, array $context = []): void
    {
        self::initLogInstance();
        self::$log->debug($message, $context);
    }

    /** @param array<string> $context */
    public static function info(string $message, array $context = []): void
    {
        self::initLogInstance();
        self::$log->info($message, $context);
    }

    /** @param array<string> $context */
    public static function notice(string $message, array $context = []): void
    {
        self::initLogInstance();
        self::$log->notice($message, $context);
    }

    /** @param array<string> $context */
    public static function warning(string $message, array $context = []): void
    {
        self::initLogInstance();
        self::$log->warning($message, $context);
    }

    /** @param array<string> $context */
    public static function error(string $message, array $context = []): void
    {
        self::initLogInstance();
        self::$log->error($message, $context);
    }

    /** @param array<string> $context */
    public static function critical(string $message, array $context = []): void
    {
        self::initLogInstance();
        self::$log->error($message, $context);
    }

    /** @param array<string> $context */
    public static function alert(string $message, array $context = []): void
    {
        self::initLogInstance();
        self::$log->alert($message, $context);
    }

    /** @param array<string> $context */
    public static function emergency(string $message, array $context = []): void
    {
        self::initLogInstance();
        self::$log->emergency($message, $context);
    }

    private static function initLogInstance(): void
    {
        if (isset(self::$log)) {
            return;
        }

        self::$log = (new Logger('buggregator'))->pushHandler(
            (new SocketHandler($_SERVER['MONOLOG_SOCKET_HOST']))
                ->setFormatter(new JsonFormatter(JsonFormatter::BATCH_MODE_NEWLINES))
        );
    }

    // XHProf

    public static function startProfiler(): void
    {
        self::initProfilerInstance();
        self::$profiler->start();
    }

    public static function endProfiler(): void
    {
        self::initProfilerInstance();
        $report = self::$profiler->disable();
        self::$profiler->save($report);
    }

    private static function initProfilerInstance(): void
    {
        if (isset(self::$profiler)) {
            return;
        }

        self::$profiler = new Profiler([
            'profiler' => Profiler::PROFILER_XHPROF,
            'profiler.enable' => function () {
                return isset($_GET['profiler']);
            },
            'save.handler' => Profiler::SAVER_STACK,
            'save.handler.upload' => [
                'url' => $_SERVER['PROFILER_ENDPOINT'],
            ],
        ]);
    }
}
