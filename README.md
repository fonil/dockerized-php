[![Integration Tests](https://github.com/fonil/dockerized-php-dev-env/actions/workflows/integration-tests.yml/badge.svg?branch=main)](https://github.com/fonil/dockerized-php-dev-env/actions/workflows/integration-tests.yml)

# Dockerized PHP Development Environment

> A lightweight PHP development environment supporting self signed local domains with Caddy    

[TOC]

## Summary

This repository allows to create a Docker services and/or microservices built with PHP.

The Docker image is based on **php:8.2.7-fpm-alpine3.18** in order to keep images as much lightweight as possible.

### Highlights

- Unified environment to build CLI or web applications with PHP8.
- Lightweight: main service Docker image only requires **83.0MB**.
- **Self-signed local domains** thanks to Caddy.

## Requirements

To use this repository it is required:

- [Docker](https://www.docker.com/) - An open source containerization platform.
- [Git](https://git-scm.com/) - The free and open source distributed version control system.

## Built with

| Type              | Component                                                                   | Description                                               |
| ----------------- | --------------------------------------------------------------------------- | --------------------------------------------------------- |
| Infrastructure    | [Docker](https://www.docker.com/)                                           | Containerization platform                                 |
| Service           | [Caddy Server](https://caddyserver.com/)                                    | Open source web server with automatic HTTPS written in Go |
| Service           | [PHP-FPM](https://www.php.net/manual/en/install.fpm.php)                    | PHP with FastCGI Process Manager                          |
| Miscelaneous      | [Bash](https://www.gnu.org/software/bash/)                                  | Allows to create an interactive shell within main service |
| Miscelaneous      | [Make](https://www.gnu.org/software/make/)                                  | Allows to execute commands defined on a _Makefile_        |
| Quality Assurance | [PCOV](https://github.com/krakjoe/pcov)                                     | Allows to generate a CodeCoverage report for PHP apps     |
| Quality Assurance | [PHP-Insights](https://phpinsights.com/)                                    | Allows to analyze the code quality of your PHP projects   |
| Quality Assurance | [PHP-Parallel-Lint](https://github.com/php-parallel-lint/PHP-Parallel-Lint) | Allows to check the syntax of PHP files in parallel       |
| Quality Assurance | [PHPStan](https://phpstan.org/)                                             | Allows to perform static analysis of your application looking for issues |
| Testing           | [Infection](https://infection.github.io/)                                   | PHP Mutation Testing Framework                            |
| Testing           | [PHPUnit](https://phpunit.de/)                                              | PHP Testing Framework                                     |
| Testing           | [Paratest](https://github.com/paratestphp/paratest)                         | Allows to run your PHPUnit test suite in parallel         |
| Testing           | [UOPZ](https://www.php.net/manual/en/book.uopz.php)                         | Allows to mock internal date/time functions on your tests |
| Testing           | [BypassFinals Hook](https://github.com/dg/bypass-finals)                    | Allows to mock PHP _final_ classes                        |

## Getting Started

Just clone the repository into your preferred path:

```bash
$ mkdir -p ~/path/to/my-new-project && cd ~/path/to/my-new-project
$ git clone git@github.com:fonil/dockerized-php-dev-env.git .
```

### Conventions

#### Application

Your application will be placed in **./src** folder.

#### Default website domain

The default website domain is **https://website.demo**

##### Customizing the default domain

If you want to customize the default website domain, please:

- Update `./etc/caddy/Caddyfile` accordingly
- Update the _Makefile_ in where a constant is defined with current domain name.

#### Directory structure

##### The Root Directory

| Folder    | Description                                                                |
| --------- | -------------------------------------------------------------------------- |
| ./etc     | The `etc` directory contains required files to properly setup the service. |
| ./src     | The `src` directory contains the source code of your application.          |
| ./targets | The `targets` directory contains the Makefile partials organized by task.  |
| ./usr     | The `usr` directory contains required files to properly setup the service. |

##### The ./etc Directory

| Folder      | Description                     |
| ----------- | ------------------------------- |
| ./etc/caddy | Contains the Caddy config file. |

##### The ./src Directory

| Folder       | Description                                                                                         |
| ------------ | --------------------------------------------------------------------------------------------------- |
| ./src/app    | The majority of your application is housed in the `app` directory. <br />By default, this directory is namespaced under `App` and is autoloaded by Composer using the [PSR-4 autoloading standard](https://www.php-fig.org/psr/psr-4/).                              |
| ./src/output | The `output` directory contains PCOV reports, file caches and other files generated by the service. |
| ./src/public | The `public` directory contains the `index.php` file which bootstraps the application.              |
| ./src/tests  | The `tests` directory contains your automated tests.                                                |
| ./src/vendor | The `vendor` directory contains your [Composer](https://getcomposer.org/) dependencies.             |
| ./src/.env   | Environment file with customized variables.                                                         |

> If you take a look to [docker-compose.yml#L13](https://github.com/fonil/dockerized-php-dev-env/blob/main/docker-compose.yml#L13) this folder is mounted as a volume into the application container.
> With this setup you are able to modify the source code of your application, within your preferred IDE, on your host and automatically have those changes in the container 😃

#### Logging

The application logs to `STDOUT` by default.

##### $_ENV

Current application uses `./src/.env` file to initialize the environment log application stream. 

By default this file contains:

```text 
APP_LOG_STREAM="php://stdout"
```

> In the `./src/public/index.php` file this `.env` is parsed and overloads the `$_ENV` global container with custom variables.

###### Testing

To avoid see log entries sent to `STDOUT` during the tests execution, the `$_ENV['APP_LOG_STREAM']` is defined as `.phpunit-log-stream`, a local file reference.  

> Please check `./src/phpunit.xml` file, and customize the **APP_LOG_STREAM** variable to your requirements.
> Changes done on here only take effect during test execution.  

##### Mocking Date/Time functions

To allow testing with date and/or time variations, [slope-it/clock-mock](https://github.com/slope-it/clock-mock) is added as dependency into `./src/composer.json`.

This library provides a way for mocking the current timestamp used by PHP for \DateTime(Immutable) objects and date/time related functions. 

> It requires the [uopz extension](https://github.com/krakjoe/uopz), that is why `Dockerfile` references to it.

#### Default Application

Default application just print outs `Class [ App\Providers\Foo ]` from `Foo` final class placed at `./src/app/Providers`.

Default unit test just verifies the class returns the correct namespace and checks the log message by reading the contents from `$_ENV['APP_LOG_STREAM']`.

> This default application has being created as a skeleton and it should be replaced by your business logic.

### Available commands

A *Makefile* is provided with some predefined commands:

```bash
~/path/to/my-new-project$ make

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                           .: AVAILABLE COMMANDS :.                           ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

· version                        Application: displays the PHP Version
· info                           Application: displays the php.init details
· linter                         Application: runs the PHP Linter in parallel mode
· phpinsights                    Application: runs the PHPInsights to fix possible issues
· infection                      Application: runs the Infection test suite
· paratest                       Application: runs the PHPUnit test suite in parallel mode
· phpunit                        Application: runs the PHPUnit test suite
· phpstan                        Application: runs PHPStan
· run                            Application: opens the website domain with your preferred browser
· composer-dump                  Composer: runs <composer dump-auto>
· composer-install               Composer: runs <composer install>
· composer-remove                Composer: runs <composer remove>
· composer-require-dev           Composer: runs <composer require --dev>
· composer-require               Composer: runs <composer require>
· composer-update                Composer: runs <composer update>
· build                          Docker: builds the service
· down                           Docker: stops the service
· up                             Docker: starts the service
· full                           Docker: starts the service + Caddy webserver
· logs                           Docker: exposes the service logs
· restart                        Docker: restarts the service
· bash                           Docker: stablish a bash session into main container
```

#### Start the service

```bash
~/path/to/my-new-project$ make build
~/path/to/my-new-project$ make run
```

##### Attention

It is important to use `make build` command instead of `docker-compose build` to create the Docker base image. The reason why is because the _Makefile_ command passes to `Dockerfile` your host account details, required to create an internal user into the application container with the same name, group and ids. 

This way avoids file permission conflicts on internally created files that needs to be shared with the host. 

##### About `make open` command

This command is a shortcut of multiple tasks needs to be done in order to expose the application throw your preferred web browser. 

Those tasks are:

1. Verifies the website domain is added to `/etc/hosts` file.
2. Ensure the PHP-FPM service has been started. 
3. Ensure the application has PHP dependencies properly installed.
4. Ensure the Caddy service has been started.

###### Certificate Authority (CA) & SSL Certificate

Caddy uses HTTPS **by default**. In order to avoid SSL certificates issues you must install the Caddy Authority Certificate on your browser. This is a one-time action due the certificate does not change after rebuilding/restarting the service.

> A *Makefile* command called `make install-authority-certificate` is provided and copies the Caddy root certificate from the Caddy container service into current application path, and displays the steps you need to follow to install this certificate in your browser. 

#### Stop the service

```bash
~/path/to/my-new-project$ make down
```

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

PHPUnit/Paratest/Infection are configured to store the PHP Code Coverage report into `./output/coverage`

##### Logs

Infection is configured to store the logs into `./output/logs/infection`

## Security Vulnerabilities

Please review our security policy on how to report security vulnerabilities:

**PLEASE DON'T DISCLOSE SECURITY-RELATED ISSUES PUBLICLY**

### Supported Versions

Only the latest major version receives security fixes.

### Reporting a Vulnerability

If you discover a security vulnerability within this project, please [open an issue here](https://github.com/fonil/dockerized-php-dev-env/issues). All security vulnerabilities will be promptly addressed.

## License

The MIT License (MIT). Please see [LICENSE](./LICENSE) file for more information.
