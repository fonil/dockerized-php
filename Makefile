.DEFAULT_GOAL := help

###
# CONSTANTS
###

ifneq (,$(findstring xterm,$(TERM)))
	BLACK   := $(shell tput -Txterm setaf 0)
	RED     := $(shell tput -Txterm setaf 1)
	GREEN   := $(shell tput -Txterm setaf 2)
	YELLOW  := $(shell tput -Txterm setaf 3)
	BLUE    := $(shell tput -Txterm setaf 4)
	MAGENTA := $(shell tput -Txterm setaf 5)
	CYAN    := $(shell tput -Txterm setaf 6)
	WHITE   := $(shell tput -Txterm setaf 7)
	RESET   := $(shell tput -Txterm sgr0)
else
	BLACK   := ""
	RED     := ""
	GREEN   := ""
	YELLOW  := ""
	BLUE    := ""
	MAGENTA := ""
	CYAN    := ""
	WHITE   := ""
	RESET   := ""
endif

HOST_USER_ID       := $(shell id --user)
HOST_USER_NAME     := $(shell id --user --name)

HOST_GROUP_ID      := $(shell id --group)
HOST_GROUP_NAME    := $(shell id --group --name)

WEBSITE_DOMAIN     = website.demo
WEBSITE_URL        = https://$(WEBSITE_DOMAIN)
BUGGREGATOR_URL    = http://localhost:8000/

SERVICE_USER_NAME        = fpm
SERVICE_NAME_APP         = app
SERVICE_NAME_CADDY       = caddy
SERVICE_NAME_BUGGREGATOR = buggregator

DOCKER_COMPOSE_FILE_PRODUCTION              = docker-compose-production.yml
DOCKER_COMPOSE_FILE_DEVELOPMENT             = docker-compose-development.yml
DOCKER_COMPOSE_FILE_DEVELOPMENT_CADDY       = docker-compose-development.caddy.yml
DOCKER_COMPOSE_FILE_DEVELOPMENT_BUGGREGATOR = docker-compose-development.buggregator.yml

DOCKER_COMPOSE                              = @docker-compose
DOCKER_COMPOSE_EXEC                         = $(DOCKER_COMPOSE) --file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) exec $(SERVICE_NAME_APP)
DOCKER_COMPOSE_EXEC_AS_USER                 = $(DOCKER_COMPOSE) --file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) exec --user=$(HOST_USER_NAME) $(SERVICE_NAME_APP)

COMPOSER_SHARED_OPTIONS   = --ignore-platform-reqs --no-scripts --no-plugins --ansi --profile
COMPOSER_OPTIMIZE_OPTIONS = --optimize-autoloader --with-all-dependencies

###
# FUNCTIONS
###

define taskDone
	@echo ""
	@echo " ${GREEN}✓${RESET}  ${GREEN}Task done!${RESET}"
	@echo ""
endef

# $(1)=NUMBER $(2)=TEXT
define orderedList
	@echo ""
	@echo " ${CYAN}$(1).${RESET}  ${CYAN}$(2)${RESET}"
	@echo ""
endef

# $(1)=TEXT $(2)=EXTRA
define showInfo
	@echo " ${YELLOW}ℹ${RESET}  $(1) $(2)"
endef

# $(1)=TEXT $(2)=EXTRA
define showAlert
	@echo " ${RED}!${RESET}  $(1) $(2)"
endef

# $(1)=CMD $(2)=OPTIONS
define runDockerCompose
	$(DOCKER_COMPOSE) $(1) $(2)
	$(call taskDone)
endef

# $(1)=CMD $(2)=OPTIONS
define runDockerComposeExec
	$(DOCKER_COMPOSE_EXEC) $(1) $(2)
	$(call taskDone)
endef

# $(1)=CMD $(2)=OPTIONS
define runDockerComposeExecAsUser
	$(DOCKER_COMPOSE_EXEC_AS_USER) $(1) $(2)
	$(call taskDone)
endef

###
# HELP
###

.PHONY: help
help:
	@clear
	@echo "╔══════════════════════════════════════════════════════════════════════════════╗"
	@echo "║                                                                              ║"
	@echo "║                           ${YELLOW}.:${RESET} AVAILABLE COMMANDS ${YELLOW}:.${RESET}                           ║"
	@echo "║                                                                              ║"
	@echo "╚══════════════════════════════════════════════════════════════════════════════╝"
	@echo ""
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "· ${YELLOW}%-30s${RESET} %s\n", $$1, $$2}'
	@echo ""

###
# MISCELANEOUS
###

.PHONY: show-context
show-context: ## Setup: show context
	$(call showInfo,"Showing context")
	@echo ""
	@echo " · Host user : (${YELLOW}${HOST_USER_ID}${RESET}) ${YELLOW}${HOST_USER_NAME}${RESET}"
	@echo " · Host group: (${YELLOW}${HOST_GROUP_ID}${RESET}) ${YELLOW}${HOST_GROUP_NAME}${RESET}"
	@echo ""
	@echo " · Service(s):"
	@echo "   - ${YELLOW}${SERVICE_NAME_APP}${RESET} (${CYAN}${DOCKER_COMPOSE_FILE_DEVELOPMENT}${RESET})"
	@echo "   - ${YELLOW}${SERVICE_NAME_CADDY}${RESET} (${CYAN}${DOCKER_COMPOSE_FILE_DEVELOPMENT_CADDY}${RESET})"
	@echo "   - ${YELLOW}${SERVICE_NAME_BUGGREGATOR}${RESET} (${CYAN}${DOCKER_COMPOSE_FILE_DEVELOPMENT_BUGGREGATOR}${RESET})"
	@echo ""
	$(call taskDone)

.PHONY: update-hosts-file
update-hosts-file: ## Setup: adds the website domain to /etc/hosts file
	$(call showInfo,"Updating [ /etc/hosts ] file may require admin password")
	@grep -qxF '127.0.0.1 $(WEBSITE_DOMAIN)' /etc/hosts || echo '127.0.0.1 $(WEBSITE_DOMAIN)\n' | sudo tee -a /etc/hosts
	$(call taskDone)

###
# DOCKER RELATED
###

.PHONY: build
build: ## Docker: builds the DEVELOPMENT service
	$(call runDockerCompose,--file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) build,--build-arg="HOST_USER_ID=$(HOST_USER_ID)" --build-arg="HOST_USER_NAME=$(HOST_USER_NAME)" --build-arg="HOST_GROUP_ID=$(HOST_GROUP_ID)" --build-arg="HOST_GROUP_NAME=$(HOST_GROUP_NAME)")

.PHONY: up
up: ## Docker: starts the PHP-FPM service
	$(call runDockerCompose,--file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) up --detach --remove-orphans)

.PHONY: down
down: ## Docker: stops the service
	$(call runDockerCompose,--file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) down --remove-orphans)

.PHONY: up-caddy
up-caddy: ## Docker: starts the Caddy webserver
	$(call runDockerCompose,--file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) --file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT_CADDY) up --detach --remove-orphans)

.PHONY: up-buggregator
up-buggregator: ## Docker: starts the Buggregator webserver
	$(call runDockerCompose,--file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) --file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT_CADDY) --file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT_BUGGREGATOR) up --detach)

.PHONY: run-caddy
run-caddy: up-caddy update-hosts-file ## Application: starts the PHP-FPM service with Caddy
	$(call showInfo,"Website ready! Please visit:",$(CYAN)$(WEBSITE_URL)$(RESET))
	@echo ""
	$(call showAlert,"Remember to install PHP dependencies by executing:",$(YELLOW)make composer-install$(RESET))
	@echo ""
	$(call showAlert,"If you experiment any issue related with SSL certificate please execute:",$(YELLOW)make install-caddy-certificate$(RESET))
	@echo ""
	$(call taskDone)

.PHONY: run-buggregator
run-buggregator: up-buggregator update-hosts-file ## Application: starts the PHP-FPM service with Caddy and Buggregator
	$(call showInfo,"Website ready! Please visit:",$(CYAN)$(WEBSITE_URL)$(RESET))
	@echo ""
	$(call showInfo,"You can visit the debug server from here:",$(CYAN)$(BUGGREGATOR_URL)$(RESET))
	@echo ""
	$(call showInfo,"You can enable XHProf at any time just by adding the following query string:",$(CYAN)$(WEBSITE_URL)?profiler$(RESET))
	@echo ""
	$(call showAlert,"Remember to install PHP dependencies by executing:",$(YELLOW)make composer-install$(RESET))
	@echo ""
	$(call showAlert,"If you experiment any issue related with SSL certificate please execute:",$(YELLOW)make install-caddy-certificate$(RESET))
	$(call taskDone)

.PHONY: logs
logs: ## Docker: exposes the service logs
	$(call runDockerCompose,--file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) logs)

.PHONY: restart
restart: ## Docker: restarts the service
	$(call runDockerCompose,--file=$(DOCKER_COMPOSE_FILE_DEVELOPMENT) restart $(SERVICE_NAME_APP))

.PHONY: bash
bash: ## Docker: establish a bash session into main container
	$(call runDockerComposeExecAsUser,bash)

###
# COMPOSER RELATED
###

.PHONY: composer-dump
composer-dump: ## Composer: runs <composer dump-auto>
	$(call runDockerComposeExecAsUser,composer dump-auto --optimize,$(COMPOSER_SHARED_OPTIONS))

.PHONY: composer-install
composer-install: ## Composer: runs <composer install>
	$(call runDockerComposeExecAsUser,composer install --optimize-autoloader,$(COMPOSER_SHARED_OPTIONS))

.PHONY: composer-remove
composer-remove: ## Composer: runs <composer remove>
	$(call runDockerComposeExecAsUser,composer remove $(COMPOSER_OPTIMIZE_OPTIONS),$(COMPOSER_SHARED_OPTIONS))

.PHONY: composer-require-dev
composer-require-dev: ## Composer: runs <composer require --dev>
	$(call runDockerComposeExecAsUser,composer require $(COMPOSER_OPTIMIZE_OPTIONS) --dev,$(COMPOSER_SHARED_OPTIONS))

.PHONY: composer-require
composer-require: ## Composer: runs <composer require>
	$(call runDockerComposeExecAsUser,composer require $(COMPOSER_OPTIMIZE_OPTIONS),$(COMPOSER_SHARED_OPTIONS))

.PHONY: composer-update
composer-update: ## Composer: runs <composer update>
	$(call runDockerComposeExecAsUser,composer update $(COMPOSER_OPTIMIZE_OPTIONS),$(COMPOSER_SHARED_OPTIONS))

###
# LINTERS & FIXERS
###

.PHONY: linter
linter: ## Application: runs the PHP Linter in parallel mode
	$(call runDockerComposeExecAsUser,./vendor/bin/parallel-lint -e php -j 10 --colors ./app ./tests)

.PHONY: phpcs
phpcs: ## Application: runs the PHPCodeSniffer to fix possible issues
	$(call runDockerComposeExecAsUser,./vendor/bin/phpcs --standard=PSR12 ./app ./tests)

.PHONY: phpcbf
phpcbf: ## Application: runs the PHPCodeBeautifier to fix possible issues
	$(call runDockerComposeExecAsUser,./vendor/bin/phpcbf --standard=PSR12 ./app ./tests)

.PHONY: phpinsights
phpinsights: ## Application: runs the PHPInsights to fix possible issues
	$(call runDockerComposeExecAsUser,./vendor/bin/phpinsights --fix)

###
# TESTING
###

.PHONY: infection
infection: ## Application: runs the Infection test suite
	$(call runDockerComposeExecAsUser,./vendor/bin/infection --configuration=infection.json --threads=3 --coverage=/output/reports/coverage --ansi)

.PHONY: paratest
paratest: ## Application: runs the PHPUnit test suite in parallel mode
	$(call runDockerComposeExecAsUser,php -d pcov.enabled=1 ./vendor/bin/paratest --passthru-php="'-d' 'pcov.enabled=1'" --coverage-text --coverage-xml=/output/reports/coverage/xml --coverage-html=/output/reports/coverage/html --log-junit=/output/reports/coverage/junit.xml)

.PHONY: phpunit
phpunit: ## Application: runs the PHPUnit test suite
	$(call runDockerComposeExecAsUser,./vendor/bin/phpunit --coverage-text --coverage-xml=/output/reports/coverage/xml --coverage-html=/output/reports/coverage/html --log-junit=/output/reports/coverage/junit.xml --coverage-cache /output/.cache/coverage)

.PHONY: phpstan
phpstan: ## Application: runs PHPStan
	$(call runDockerComposeExecAsUser,./vendor/bin/phpstan analyse --level 9 --memory-limit 1G --ansi ./app ./tests)

.PHONY: tests
tests: up paratest infection ## Application: runs ParaTest + Infection

###
# APPLICATION SERVICE
###

.PHONY: version
version: ## Application: displays the PHP Version
	$(call runDockerComposeExecAsUser,php -v)

.PHONY: info
info: ## Application: displays the php.ini details
	$(call runDockerComposeExecAsUser,php -i)

###
# CADDY RELATED
###

.PHONY: install-caddy-certificate
install-caddy-certificate: ## Caddy: installs Caddy Local Authority certificate
	@echo "Installing [ $(YELLOW)Caddy Local Authority - 20XX ECC Root$(RESET) ] as a valid Certificate Authority"
	$(call orderedList,1,"Copy the root certificate from Caddy Docker container")
	@docker-compose cp $(SERVICE_NAME_CADDY):/data/caddy/pki/authorities/local/root.crt ./caddy-root-ca-authority.crt
	$(call orderedList,2,"Install the Caddy Authority certificate into your browser")
	@echo "$(YELLOW)Chrome-based browsers (Chrome, Brave, etc)$(RESET)"
	@echo "- Go to [ Settings / Privacy & Security / Security / Manage Certificates / Authorities ]"
	@echo "- Import [ ./caddy-root-ca-authority.crt ]"
	@echo "- Check on [ Trust this certificate for identifying websites ]"
	@echo "- Save changes"
	@echo ""
	@echo "$(YELLOW)Firefox browser$(RESET)"
	@echo "- Go to [ Settings / Privacy & Security / Security / Certificates / View Certificates / Authorities ]"
	@echo "- Import [ ./caddy-root-ca-authority.crt ]"
	@echo "- Check on [ This certificate can identify websites ]"
	@echo "- Save changes"
	@echo ""
	$(call showInfo,"For further information, please visit https://caddyserver.com/docs/running#docker-compose")
	$(call taskDone)

###
# PRODUCTION RELATED
###

.PHONY: check-production
check-production: update-hosts-file ## Docker: Checks the service(s) in PRODUCTION mode
	@docker build --target=build-production --tag $(SERVICE_NAME_APP):production .
	$(call runDockerCompose,--file=$(DOCKER_COMPOSE_FILE_PRODUCTION) up --detach --remove-orphans)
	$(call showInfo,"Website ready! Please visit:",$(CYAN)$(WEBSITE_URL)$(RESET))
	@echo ""
	$(call showAlert,"If you experiment any issue related with SSL certificate please execute:",$(YELLOW)make install-caddy-certificate$(RESET))
	@echo ""
	$(call taskDone)