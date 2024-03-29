[![Integration Tests](https://github.com/fonil/dockerized-php/actions/workflows/integration-tests.yml/badge.svg?branch=main)](https://github.com/fonil/dockerized-php/actions/workflows/integration-tests.yml)

# Dockerized PHP

> A Docker container containing PHP-FPM

[TOC]

## Summary

This repository contains a Docker container based on **php:8.3.3-fpm-alpine** allowing you to create <u>microservices</u> and/or <u>web applications</u> using Caddy.

### Highlights

- **Self-signed local domains** thanks to Caddy.
- Unified environment to build CLI and/or web applications with **PHP8**.
- Code Coverage, PHPUnit, Paratest, PHPInsights, PHPStan and Linters by default.
- Allows you to create an **optimized production-ready** Docker image. 
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

To avoid any possible file permissions between host and shared volumes with the container service, a non-root user is created into the container with same credentials than the host user and forcing to PHP-FPM to be running as this user. With this setup any recently created file in the container service can be shared with the host without any file permission issue. 

Those details are collected from the `Makefile` and passing the values to Dockerfile as build arguments: 

| Argument          | How to fill the value | Description                |
| ----------------- | --------------------- | -------------------------- |
| `HOST_USER_NAME`  | `$ id --user --name`  | Current host user name     |
| `HOST_GROUP_NAME` | `$ id --group --name` | Current host group name    |
| `HOST_USER_ID`    | `$ id --user`         | Current host user ID       |
| `HOST_GROUP_ID`   | `$ id --group`        | Current host user group ID |

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

#### Mocking Date/Time functions

To allow testing with date and/or time variations, [slope-it/clock-mock](https://github.com/slope-it/clock-mock) is added as dependency into `src/composer.json`.

This library provides a way for mocking the current timestamp used by PHP for `\DateTime(Immutable)` objects and date/time related functions. 

> It requires the [uopz extension](https://github.com/krakjoe/uopz), that is why `Dockerfile` references to it.

#### Application Business Logic

Default application just print outs `Class [ App\Providers\Foo ]` from `Foo` final class placed at `src/app/Providers`.

Default unit test just verifies the instance returns.

> This default application has being created as a skeleton and it should be replaced by your business logic.

#### Certificate Authority (CA) & SSL Certificate

<u>Caddy uses HTTPS by default</u>. In order to avoid SSL certificates issues you must install the Caddy Authority Certificate on your browser. This is a one-time action due the certificate does not change after rebuilding/restarting the service.

> A _Makefile_ command called `make install-caddy-certificate` is provided and copies the Caddy root certificate from the Caddy container service into current application path, and displays the steps you need to follow to install this certificate in your browser. 

#### Docker Compose files

As you can see there are several docker compose files:

| Docker Compose file name                     | Environment | Description                                                  |
| -------------------------------------------- | ----------- | ------------------------------------------------------------ |
| `docker-compose-development.yml`             | DEVELOPMENT | Application service Docker Compose file for **DEVELOPMENT** environment |
| `docker-compose-development.caddy.yml`       | DEVELOPMENT | Caddy service Docker Compose file                            |
| `docker-compose-development.buggregator.yml` | DEVELOPMENT | Buggregator service Docker Compose file                      |
| `docker-compose-production.yml`              | PRODUCTION  | Application service Docker Compose file for **PRODUCTION** environment |

> With this setup you can develop microservices and/or web applications just by combining those file accordingly

### Environments

#### Development

Development environment allows you to develop, test and debug your application using PHPUnit, PCOV, Infection and mock Date/Time functions on your tests. Additionally you can debug and profile your application using Buggregator, which includes XHProf and that is why some specific extensions are required on the development Dockerfile stage for this environment. 

#### Production

Production environment allows you deploy the generated container service without any development extension.

#### Development vs Production

##### Applicacions & Extensions

| Extensions | DEVELOPMENT | PRODUCTION | Description                                                  |
| ---------- | ----------- | ---------- | ------------------------------------------------------------ |
| FCGI       | ✓           | ✓          | Required to perform the Docker health check                  |
| Bash       | ✓           | ⨉          | Required to establish a Bash terminal between host and container service |
| PCOV       | ✓           | ⨉          | Required to generate Code Coverage reports                   |
| UOPZ       | ✓           | ⨉          | Required to mock Date/Time functions on your tests           |
| XHPROF     | ✓           | ⨉          | Required to profile the application using XHProf             |

##### Volumes

| Volumes  | DEVELOPMENT | PRODUCTION | Description                                |
| -------- | ----------- | ---------- | ------------------------------------------ |
| `src`    | ✓           | ⨉          | Volume required to sync host and container |
| `output` | ✓           | ⨉          | Volume required to sync host and container |

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
· install-caddy-certificate      Setup: installs Caddy Local Authority certificate
· build                          Docker: builds the DEVELOPMENT service
· up                             Docker: starts the PHP-FPM service
· up-caddy                       Docker: starts the Caddy service
· up-buggregator                 Docker: starts the Buggregator service
· restart                        Docker: restarts the PHP-FPM service
· restart-caddy                  Docker: restarts the Caddy service
· restart-buggregator            Docker: restarts the Buggregatgor service
· down                           Docker: stops the service(s)
· logs                           Docker: exposes the service logs
· bash                           Docker: establish a bash session into main container
· run-caddy                      Docker: starts the PHP-FPM service with Caddy
· run-buggregator                Docker: starts the PHP-FPM service with Caddy and Buggregator
· composer-dump                  Application: <composer dump-auto>
· composer-install               Application: <composer install>
· composer-remove                Application: <composer remove>
· composer-require-dev           Application: <composer require --dev>
· composer-require               Application: <composer require>
· composer-update                Application: <composer update>
· linter                         Application: <composer linter>
· phpcs                          Application: <composer phpcbs>
· phpcbf                         Application: <composer phpcbf>
· phpstan                        Application: <composer phpstan>
· phpinsights                    Application: <composer phpinsights>
· mutation                       Application: <composer test-mutation>
· paratest                       Application: <composer paratest>
· phpunit                        Application: <composer test>
· tests                          Application: runs ParaTest + Mutation
· version                        Application: displays the PHP Version
· info                           Application: displays the php.ini details
· check-production               Miscelaneous: Checks the service(s) in PRODUCTION mode
```

#### Environments

##### Development

###### Build the service

```bash
~/path/to/my-new-project$ make build
```

###### Run only PHP-FPM

```bash
~/path/to/my-new-project$ make up
```

###### Run PHP-FPM + Caddy

```bash
~/path/to/my-new-project$ make up-caddy
```

###### Run PHP-FPM + Caddy + Buggregator

```bash
~/path/to/my-new-project$ make up-buggregator
```

###### Stop the service

```bash
~/path/to/my-new-project$ make down
```

##### Production

###### Check the service

```bash
~/path/to/my-new-project$ make check-production
```

In order to simplify this process, this command performs the following actions:

- As this example is a web application, ensure the domain entry is present in you `/etc/hosts` file. 
- Build the container service using `docker-compose-production.yml`file
- Start the service in cooperation with a Caddy server using the default `Caddyfile` 

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
~/path/to/my-new-project$ make mutation
```

> This command executes the mutation testing tool

## Security Vulnerabilities

Please review our security policy on how to report security vulnerabilities:

**PLEASE DON'T DISCLOSE SECURITY-RELATED ISSUES PUBLICLY**

### Supported Versions

Only the latest major version receives security fixes.

### Reporting a Vulnerability

If you discover a security vulnerability within this project, please [open an issue here](https://github.com/fonil/dockerized-php/issues). All security vulnerabilities will be promptly addressed.

## License

The MIT License (MIT). Please see [LICENSE](./LICENSE) file for more information.
