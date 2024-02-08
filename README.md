[![Integration Tests](https://github.com/fonil/dockerized-php/actions/workflows/integration-tests.yml/badge.svg?branch=main)](https://github.com/fonil/dockerized-php/actions/workflows/integration-tests.yml)

# Dockerized PHP

> A dockerized lightweight PHP development environment supporting **self signed local domains** powered by Caddy

[TOC]

## Summary

This repository allows you to create containerized PHP applications and/or microservices using Docker and Caddy.

The Docker image is based on **php:8.3.2-fpm-alpine3.19** in order to keep bade image as much lightweight as possible.

### Highlights

- **Self-signed local domains** thanks to Caddy.
- Unified environment to build **CLI** and/or web applications with **PHP8**.
- Code Coverage, PHPUnit, Paratest, PHPInsights, PHPStan and Linters by default.
- Includes [Buggregator](https://buggregator.dev) as main debug server.

## Requirements

To use this repository you need:

- [Docker](https://www.docker.com/) - An open source containerization platform.
- [Git](https://git-scm.com/) - The free and open source distributed version control system.

## Built with

| Type              | Component                                                                   | Description                                                              |
| ----------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| Infrastructure    | [Docker](https://www.docker.com/)                                           | Containerization platform                                                |
| Service           | [Caddy Server](https://caddyserver.com/)                                    | Open source web server with automatic HTTPS written in Go                |
| Service           | [PHP-FPM](https://www.php.net/manual/en/install.fpm.php)                    | PHP with FastCGI Process Manager                                         |
| Service           | [Buggregator](https://buggregator.dev)                                      | Debug server providing support to VarDump, Monolog, Sentry...            |
| Miscelaneous      | [Bash](https://www.gnu.org/software/bash/)                                  | Allows to create an interactive shell within main service                |
| Miscelaneous      | [Make](https://www.gnu.org/software/make/)                                  | Allows to execute commands defined on a _Makefile_                       |
| Quality Assurance | [PCOV](https://github.com/krakjoe/pcov)                                     | Allows to generate a CodeCoverage report for PHP apps                    |
| Quality Assurance | [PHP-Insights](https://phpinsights.com/)                                    | Allows to analyze the code quality of your PHP projects                  |
| Quality Assurance | [PHP-Parallel-Lint](https://github.com/php-parallel-lint/PHP-Parallel-Lint) | Allows to check the syntax of PHP files in parallel                      |
| Quality Assurance | [PHPStan](https://phpstan.org/)                                             | Allows to perform static analysis of your application looking for issues |
| Testing           | [Infection](https://infection.github.io/)                                   | PHP Mutation Testing Framework                                           |
| Testing           | [PHPUnit](https://phpunit.de/)                                              | PHP Testing Framework                                                    |
| Testing           | [Paratest](https://github.com/paratestphp/paratest)                         | Allows to run your PHPUnit test suite in parallel                        |
| Testing           | [UOPZ](https://www.php.net/manual/en/book.uopz.php)                         | Allows to mock internal date/time functions on your tests                |
| Testing           | [BypassFinals Hook](https://github.com/dg/bypass-finals)                    | Allows to mock PHP _final_ classes                                       |

## Getting Started

Just clone the repository into your preferred path:

```bash
$ mkdir -p ~/path/to/my-new-project && cd ~/path/to/my-new-project
$ git clone git@github.com:fonil/dockerized-php.git .
```

### Conventions

#### Build Arguments

To avoid conflicts with ownership and/or file permission from those files internally created by the container service, a non-root user is created into the service with the same ID and group name than the current host user, and forcing the service to be executed with this user and group when creating files.

Those details are in the `Makefile` file and contains the following arguments. 

| Argument          | How to fill the value | Description                |
| ----------------- | --------------------- | -------------------------- |
| `HOST_USER_NAME`  | `$ id --user --name`  | Current host user name     |
| `HOST_GROUP_NAME` | `$ id --group --name` | Current host group name    |
| `HOST_USER_ID`    | `$ id --user`         | Current host user ID       |
| `HOST_GROUP_ID`   | `$ id --group`        | Current host user group ID |

> Defining those variables here allows you to execute any *Makefile* command (`make build`, `make up`...) with 100% compatibility.  

#### Application

Your application must be placed into `src` folder.

#### Default website domain

The default website domain is `https://website.demo`

##### Customizing the default domain

If you want to customize the default website domain please:

- Update `build/etc/caddy/Caddyfile` accordingly
- Update the _Makefile_ in where a constant is defined with current domain name.

#### Directory structure

```text
.
├── build
│   ├── dev/usr/local/etc/php-fpm.d/www.conf        # PHP-FPM configuration file for DEVELOPMENT environment
│   ├── prod/usr/local/etc/php-fpm.d/www.conf       # PHP-FPM configuration file for DEVELOPMENT environment
│   └── shared
│       ├── etc/caddy/Caddyfile                     # Caddy configuration file
│       └── usr/shared/healthchecks/php-fpm.sh      # Shell script acting as healthcheck for main service application
├── docker-compose-development.buggregator.yml      # docker-compose.yml with Buggregator service
├── docker-compose-development.caddy.yml            # docker-compose.yml with Caddy service
├── docker-compose-development.yml                  # docker-compose.yml for DEVELOPMENT environment
├── docker-compose-production.yml                   # docker-compose.yml for PRODUCTION environment
├── Dockerfile                                      # Multi-stage Dockerfile
├── Makefile
├── output                                          # Folder where logs and internally created files are stored
│   ├── logs                                        # Infection logs
│   │   ├── infection.html
│   │   ├── infection.log
│   │   ├── infection-log.json
│   │   ├── infection-per-mutator.md
│   │   └── infection-summary.log
│   └── reports                                     # PCOV reports
│       └── coverage
│           ├── html
│           └── xml
├── README.md
└── src                                             # Application service business logic
    ├── app
    │   ├── Debug
    │   │   └── Buggregator.php                     # Buggregator bootstrap class
    │   └── Providers
    │       └── Foo.php
    ├── composer.json
    ├── composer.lock
    ├── infection.json
    ├── phpcs.xml
    ├── phpinsights.php
    ├── phpstan.neon.dist
    ├── phpunit.xml
    ├── public
    │   ├── index-debug.php                         # Main application service entry point with Buggregator enabled
    │   └── index.php                               # Main application service entry point
    ├── tests                                       # Test cases
    │   ├── Hooks
    │   │   └── BypassFinalHook.php
    │   └── Unit
    │       └── Providers
    │           └── FooTest.php
    └── vendor                                      # Application service dependencies
```

#### Logging

The application logs to `STDOUT` by default.

##### Mocking Date/Time functions

To allow testing with date and/or time variations, [slope-it/clock-mock](https://github.com/slope-it/clock-mock) is added as dependency into `src/composer.json`.

This library provides a way for mocking the current timestamp used by PHP for `\DateTime(Immutable)` objects and date/time related functions. 

> It requires the [uopz extension](https://github.com/krakjoe/uopz), that is why `Dockerfile` references to it.

#### Default Application

Default application just print outs `Class [ App\Providers\Foo ]` from `Foo` final class placed at `src/app/Providers`.

Default unit test just verifies the instance returns.

> This default application has being created as a skeleton and it should be replaced by your business logic.

#### Certificate Authority (CA) & SSL Certificate

<u>Caddy uses HTTPS by default</u>. In order to avoid SSL certificates issues you must install the Caddy Authority Certificate on your browser. This is a one-time action due the certificate does not change after rebuilding/restarting the service.

> A _Makefile_ command called `make install-caddy-certificate` is provided and copies the Caddy root certificate from the Caddy container service into current application path, and displays the steps you need to follow to install this certificate in your browser. 

### Environments

The container service on development environment requires some debugging extensions than the production environment doesn't require and the way the source code is mounted into each environment differs:  

#### Development

On development environment the source code is mounted as a synchronized volume between the host and the container service, so any change on the source code from the host is automatically synchronized inside the service container.

#### Production

On production environment the source code is copied into the service container like an snapshot, which is the standard way to deploy PHP applications. 

### Available commands

A _Makefile_ is provided with some predefined commands:

```bash
~/path/to/my-new-project$ make

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                           .: AVAILABLE COMMANDS :.                           ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

· show-context                   Setup: show context
· update-hosts-file              Setup: adds the website domain to /etc/hosts file
· build                          Docker: builds the DEVELOPMENT service
· up                             Docker: starts the PHP-FPM service
· down                           Docker: stops the service
· up-caddy                       Docker: starts the Caddy webserver
· up-buggregator                 Docker: starts the Buggregator webserver
· run-caddy                      Application: starts the PHP-FPM service with Caddy
· run-buggregator                Application: starts the PHP-FPM service with Caddy and Buggregator
· logs                           Docker: exposes the service logs
· restart                        Docker: restarts the service
· bash                           Docker: establish a bash session into main container
· composer-dump                  Composer: runs <composer dump-auto>
· composer-install               Composer: runs <composer install>
· composer-remove                Composer: runs <composer remove>
· composer-require-dev           Composer: runs <composer require --dev>
· composer-require               Composer: runs <composer require>
· composer-update                Composer: runs <composer update>
· linter                         Application: runs the PHP Linter in parallel mode
· phpcs                          Application: runs the PHPCodeSniffer to fix possible issues
· phpcbf                         Application: runs the PHPCodeBeautifier to fix possible issues
· phpinsights                    Application: runs the PHPInsights to fix possible issues
· infection                      Application: runs the Infection test suite
· paratest                       Application: runs the PHPUnit test suite in parallel mode
· phpunit                        Application: runs the PHPUnit test suite
· phpstan                        Application: runs PHPStan
· tests                          Application: runs ParaTest + Infection
· version                        Application: displays the PHP Version
· info                           Application: displays the php.ini details
· install-caddy-certificate      Caddy: installs Caddy Local Authority certificate
· check-prod                     Docker: Checks the service(s) in PRODUCTION mode
```

#### Development Environment

##### Build the service

```bash
~/path/to/my-new-project$ make build
```

##### Run the service

###### Only the PHP-FPM service

```bash
~/path/to/my-new-project$ make up
```

###### PHP-FPM + Caddy

```bash
~/path/to/my-new-project$ make up-caddy
```

###### PHP-FPM + Caddy + Buggregator

```bash
~/path/to/my-new-project$ make up-buggregator
```

##### Stop the service

```bash
~/path/to/my-new-project$ make down
```

#### Production Environment

##### Check the service

```bash
~/path/to/my-new-project$ make check-production
```

This command performs the following tasks:

- Ensure the domain name is present in you `/etc/hosts` file. If not present, your user password is requested in order to add the entry line.
- Build the container service using `docker-compose-production.yml`file

#### Dealing with Code Quality

```bash
~/path/to/my-new-project$ make linter
```

```bash
~/path/to/my-new-project$ make phpinsights
```

```bash
~/path/to/my-new-project$ make phpstan
```

#### Dealing with Tests

```bash
~/path/to/my-new-project$ make phpunit
```

> This command executes PHPUnit


```bash
~/path/to/my-new-project$ make paratest
```

> This command executes PHPUnit in parallel mode

```bash
~/path/to/my-new-project$ make infection
```

> This command executes the mutation testing tool

##### Reports

PHPUnit/Paratest/Infection are configured to store the PHP Code Coverage report into `output/coverage`

##### Logs

Infection is configured to store the logs into `output/logs/infection`

## Security Vulnerabilities

Please review our security policy on how to report security vulnerabilities:

**PLEASE DON'T DISCLOSE SECURITY-RELATED ISSUES PUBLICLY**

### Supported Versions

Only the latest major version receives security fixes.

### Reporting a Vulnerability

If you discover a security vulnerability within this project, please [open an issue here](https://github.com/fonil/dockerized-php/issues). All security vulnerabilities will be promptly addressed.

## License

The MIT License (MIT). Please see [LICENSE](./LICENSE) file for more information.
