###
# PHP RELATED
###

version: ## Application: displays the PHP Version
	$(call runDockerComposeExec,php -v)

info: ## Application: displays the php.init details
	$(call runDockerComposeExec,php -i)

###
# LINTERS & FIXERS
###

linter: ## Application: runs the PHP Linter in parallel mode
	$(call runDockerComposeExec,./vendor/bin/parallel-lint -e php -j 10 --colors ./app ./tests)

phpinsights: ## Application: runs the PHPInsights to fix possible issues
	$(call runDockerComposeExec,./vendor/bin/phpinsights --fix)

###
# TESTING
###

infection: ## Application: runs the Infection test suite
	$(call runDockerComposeExec,./vendor/bin/infection --configuration=infection.json --threads=3 --coverage=./output/reports/coverage --ansi)

paratest: ## Application: runs the PHPUnit test suite in parallel mode
	$(call runDockerComposeExec,php -d pcov.enabled=1 ./vendor/bin/paratest --passthru-php="'-d' 'pcov.enabled=1'" --coverage-text --coverage-xml=./output/reports/coverage/xml --coverage-html=./output/reports/coverage/html --log-junit=./output/reports/coverage/junit.xml)

phpunit: ## Application: runs the PHPUnit test suite
	$(call runDockerComposeExec,./vendor/bin/phpunit --coverage-text --coverage-xml=./output/reports/coverage/xml --coverage-html=./output/reports/coverage/html --log-junit=./output/reports/coverage/junit.xml --coverage-cache ./output/.cache/coverage)

phpstan: ## Application: runs PHPStan
	$(call runDockerComposeExec,./vendor/bin/phpstan analyse --level 9 --memory-limit 1G --ansi ./app ./tests)

###
# DEVELOPMENT SETUP
###

add-to-hosts: # Application: adds the website domain to /etc/hosts file
	$(call showInfo,"Updating [ /etc/hosts ] file may require admin password")
	@grep -qxF '127.0.0.1    $(WEBSITE_DOMAIN)' /etc/hosts || echo '127.0.0.1    $(WEBSITE_DOMAIN)' | sudo tee -a /etc/hosts
	$(call taskDone)

###
# MISCELANEOUS
###

open: add-to-hosts up-with-caddy composer-install ## Application: opens the website domain with your preferred browser
	$(call showInfo,"Opening [ $(WEBSITE_URL) ] with your preferred browser")
	$(call showInfo,"You can press [ Ctrl+C ] to return the terminal")
	$(call showAlert,"If [ $(WEBSITE_URL) ] has a SSL certificate issue please execute:",$(YELLOW)make install-authority-certificate$(RESET))
	@open $(WEBSITE_URL)
	$(call taskDone)
