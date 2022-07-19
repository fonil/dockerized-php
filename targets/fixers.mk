linter: CMD=./vendor/bin/parallel-lint -e php -j 10 --colors ./app ./tests
phpinsights: CMD=./vendor/bin/phpinsights --fix

linter phpinsights:
	$(call runDockerComposeExec,$(CMD))

# SHORTCUTS

fix: linter phpinsights  ## Fixes the source code to follow the standards
