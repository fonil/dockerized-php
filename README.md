# Dockerized PHP

> A skeleton to build containerized microservices with Docker and based on PHP


[TOC]

## Requirements

To use this repository it is required:

- [Docker](https://www.docker.com/) - An open source containerization platform.
- [Git](https://git-scm.com/) -  The free and open source distributed version control system.

## Built with

This project has been built using the following tools:

- [Docker](https://www.docker.com/) - An open source containerization platform.
- [Bash](https://www.gnu.org/software/bash/) - The GNU Project's shell.
- [Make](https://www.gnu.org/software/make/) - GNU make utility to maintain groups of programs.
- [nginx](https://www.nginx.com/) - Advanced Load Balancer, Web Server &amp; Reverse Proxy.
- [PHP-FPM](https://www.php.net/manual/en/install.fpm.php) - FastCGI Process Manager is a primary PHP implementation containing some features (mostly) useful for heavy-loaded sites.
  - [Infection](https://infection.github.io/) - PHP Mutation Testing Framework.
  - [PCOV](https://github.com/krakjoe/pcov) - A self contained CodeCoverage for PHP.
  - [PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer) - PHP Coding Standards Fixer.
  - [PHP-Parallel-Lint](https://github.com/php-parallel-lint/PHP-Parallel-Lint) - PHP Parallel Syntax Analyzer.
  - [PHPMetrics](https://phpmetrics.org/) - PHP Metrics.
  - [PHPStan](https://phpstan.org/) - PHP Static Analyzer.
  - [PHPUnit](https://phpunit.de/) - PHP Testing Framework.
    - [Paratest](https://github.com/paratestphp/paratest) - Adds parallel testing support in PHPUnit.
    - [PHPUnit Result Printer](https://github.com/mikeerickson/phpunit-pretty-result-printer) - Extends the default PHPUnit Result Printer.

## Getting Started

Just clone the repository into your preferred path:

```bash
$ mkdir -p ~/path/to/my-new-project && cd ~/path/to/my-new-project
$ git clone git@github.com:fonil/dockerized-php.git .
```

### Assumptions

#### Application URL

The default domain responds to **[http://localhost](http://localhost)**.

#### Logging

The application logs to **standard output** by default.

### Commands

A *Makefile* is provided with some predefined commands:

```bash
~/path/to/my-new-project$ make

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                           .: AVAILABLE COMMANDS :.                           ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

· bash                           Starts a Bash session
· build                          Builds the service
· composer-dump                  Runs <composer dump-auto>
· composer-install               Runs <composer install>
· composer-remove                Runs <composer remove PACKAGE-NAME>
· composer-require               Runs <composer require>
· composer-require-dev           Runs <composer require-dev>
· composer-update                Runs <composer update>
· down                           Stops the service
· fix                            Fixes the source code to follow the standards
· logs                           Exposes the logs
· metrics                        Generates a report with relevant metrics
· restart                        Restarts the service
· tests                          Runs the tests suites
· up                             Starts the service
· version                        Displays the PHP version
```

#### Build the service

```bash
~/path/to/my-new-project$ make build
```

#### Start the service

```bash
~/path/to/my-new-project$ make up
```

#### Display service information

```bash
~/path/to/my-new-project$ make version
```

#### Check service logs

##### All combined

```bash
~/path/to/my-new-project$ make logs
```

##### Only about PHP-FPM

```bash
~/path/to/my-new-project$ make logs php-fpm
```

##### Only about Nginx

```bash
~/path/to/my-new-project$ make logs nginx
```

#### Bash to main service

```bash
~/path/to/my-new-project$ make bash
```

#### Dealing with PHP dependencies

##### Install Dependencies

```bash
~/path/to/my-new-project$ make composer-install
```

##### Update Dependencies

```bash
~/path/to/my-new-project$ make composer-update
```

##### Require a Dependency

```bash
~/path/to/my-new-project$ make composer-require
```

##### Remove a Dependency

```bash
~/path/to/my-new-project$ make composer-remove xxxxxxx
```

##### Rebuild the Dependency Tree

```bash
~/path/to/my-new-project$ make composer-dump
```

#### Stop the service

##### Remove a Dependency

```bash
~/path/to/my-new-project$ make down
```

#### Dealing with Code Quality

```bash
~/path/to/my-new-project$ make fix
```

> Note that this command is an alias that executes PHP Linter + PHP-CS-Fixer

#### Dealing with Tests

```bash
~/path/to/my-new-project$ make tests
```

> Note that this command is an alias that executes PHPStan + Paratest + Infection

##### Reports

PHPUnit/Paratest/Infection are configured to store the PHP Code Coverage report at `./reports/coverage`

##### Logs

Infection is configured to store the logs at `./logs/infection`

#### Generating some Metrics

```bash
~/path/to/my-new-project$ make metrics
```

##### Reports

PHPMetrics is configured to store the report at `./reports/metrics`

## Security Vulnerabilities

Please review our security policy on how to report security vulnerabilities:

**PLEASE DON'T DISCLOSE SECURITY-RELATED ISSUES PUBLICLY**

### Supported Versions

Only the latest major version receives security fixes.

### Reporting a Vulnerability

If you discover a security vulnerability within this project, please [open an issue here](https://github.com/fonil/dockerized-php/issues). All security vulnerabilities will be promptly addressed.

## License

This project is an open-sourced software licensed under the [The Unlicense](https://github.com/fonil/dockerized-php/main/LICENSE).