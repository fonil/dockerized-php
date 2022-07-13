bash: CMD=bash 										## Starts a Bash session
build: CMD=build 									## Builds the service
down: CMD=down 										## Stops the service
logs: CMD=logs $(filter-out $@,$(MAKECMDGOALS))     ## Exposes the logs
restart: CMD=restart $(SERVICE_NAME) 				## Restarts the service
up: CMD=up --remove-orphans -d 						## Starts the service

build down logs restart up:
	$(call runDockerCompose,$(CMD))

bash:
	$(call runDockerComposeExec,$(CMD))
