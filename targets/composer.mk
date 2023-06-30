COMPOSER_SHARED_OPTIONS=--ignore-platform-reqs --no-scripts --no-plugins --ansi --profile
COMPOSER_OPTIMIZE_OPTIONS=--optimize-autoloader --with-all-dependencies

composer-dump: ## Composer: runs <composer dump-auto>
	$(call runDockerComposeExec,composer dump-auto --optimize,$(COMPOSER_SHARED_OPTIONS))

composer-install: ## Composer: runs <composer install>
	$(call runDockerComposeExec,composer install --optimize-autoloader,$(COMPOSER_SHARED_OPTIONS))

composer-remove: ## Composer: runs <composer remove>
	$(call runDockerComposeExec,composer remove $(COMPOSER_OPTIMIZE_OPTIONS),$(COMPOSER_SHARED_OPTIONS))

composer-require-dev: ## Composer: runs <composer require --dev>
	$(call runDockerComposeExec,composer require $(COMPOSER_OPTIMIZE_OPTIONS) --dev,$(COMPOSER_SHARED_OPTIONS))

composer-require: ## Composer: runs <composer require>
	$(call runDockerComposeExec,composer require $(COMPOSER_OPTIMIZE_OPTIONS),$(COMPOSER_SHARED_OPTIONS))

composer-update: ## Composer: runs <composer update>
	$(call runDockerComposeExec,composer update $(COMPOSER_OPTIMIZE_OPTIONS),$(COMPOSER_SHARED_OPTIONS))
