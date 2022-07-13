linter: CMD=./vendor/bin/parallel-lint -e php -j 10 --colors ./app ./tests
phpcsfixer: CMD=./vendor/bin/php-cs-fixer fix --using-cache=no --ansi

linter phpcsfixer:
	$(call runDockerComposeExec,$(CMD))

# SHORTCUTS

fix: linter phpcsfixer  ## Fixes the source code to follow the standards
