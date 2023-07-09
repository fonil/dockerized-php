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

UID   := $(shell id --user)
GID   := $(shell id --group)
UNAME := $(shell id --user --name)
GNAME := $(shell id --group --name)

WEBSITE_DOMAIN      = website.demo
WEBSITE_URL         = https://$(WEBSITE_DOMAIN)

SERVICE_NAME_APP    = app
SERVICE_NAME_CADDY  = caddy

DOCKER_COMPOSE              = @docker-compose
DOCKER_COMPOSE_EXEC         = $(DOCKER_COMPOSE) exec $(SERVICE_NAME_APP)
DOCKER_COMPOSE_EXEC_AS_USER = $(DOCKER_COMPOSE) exec --user=$(UNAME) $(SERVICE_NAME_APP)

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
# MAKEFILE TARGETS
###

-include $(SELF_DIR)/targets/*.mk
