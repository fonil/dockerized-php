build: ## Docker: builds the service
	$(call runDockerCompose,build)

down: ## Docker: stops the service
	$(call runDockerCompose,down --remove-orphans)

up: ## Docker: starts the service
	$(call runDockerCompose,--file docker-compose.yml up --remove-orphans --detach)

full: ## Docker: starts the service + Caddy webserver
	$(call runDockerCompose,--file docker-compose.yml --file docker-compose.caddy.yml up --remove-orphans --detach)

logs: ## Docker: exposes the service logs
	$(call runDockerCompose,logs)

restart: ## Docker: restarts the service
	$(call runDockerCompose,restart $(SERVICE_NAME_APP))

bash: ## Docker: stablish a bash session into main container
	$(call runDockerComposeExec,bash)
