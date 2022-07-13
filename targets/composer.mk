composer-dump: CMD=composer dump-auto --optimize 																	## Runs <composer dump-auto>
composer-install: CMD=composer install --optimize-autoloader														## Runs <composer install>
composer-remove: CMD=composer remove --optimize-autoloader --with-all-dependencies $(filter-out $@,$(MAKECMDGOALS))	## Runs <composer remove PACKAGE-NAME>
composer-require-dev: CMD=composer require --optimize-autoloader --with-all-dependencies --dev						## Runs <composer require-dev>
composer-require: CMD=composer require --optimize-autoloader --with-all-dependencies								## Runs <composer require>
composer-update: CMD=composer update --optimize-autoloader --with-all-dependencies									## Runs <composer update>

composer-dump composer-install composer-remove composer-require-dev composer-require composer-update:
	$(call runDockerComposeExec,${CMD},--ignore-platform-reqs --no-scripts --no-plugins --ansi --profile)
