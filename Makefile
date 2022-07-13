.DEFAULT_GOAL := help

###
# CONSTANTS
###

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

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

SERVICE_NAME 		= php-fpm

DOCKER_COMPOSE 		= @docker-compose
DOCKER_COMPOSE_EXEC = $(DOCKER_COMPOSE) exec $(SERVICE_NAME)

###
# FUNCTIONS
###

# $(1)=CMD $(2)=OPTIONS
define runDockerCompose
	$(DOCKER_COMPOSE) $(1) $(2)
	@echo ""
endef

# $(1)=CMD $(2)=OPTIONS
define runDockerComposeExec
	$(DOCKER_COMPOSE_EXEC) $(1) $(2)
	@echo ""
endef

###
# MAKEFILE TARGETS
###

-include $(SELF_DIR)/targets/*.mk
