infection: CMD=./vendor/bin/infection --configuration=infection.json --threads=3 --coverage=./.reports/coverage --ansi
paratest: CMD=php -d pcov.enabled=1 vendor/bin/paratest --passthru-php="'-d' 'pcov.enabled=1'" --coverage-text --coverage-xml=./.reports/coverage/xml --coverage-html=./.reports/coverage/html --log-junit=./.reports/coverage/junit.xml
phpunit: CMD=./vendor/bin/phpunit --coverage-text --coverage-xml=./.reports/coverage/xml --coverage-html=./.reports/coverage/html --log-junit=./.reports/coverage/junit.xml --coverage-cache .cache/coverage
phpstan: CMD=./vendor/bin/phpstan analyse --level 9 --memory-limit 1G --ansi ./app ./tests

infection paratest phpunit phpstan:
	$(call runDockerComposeExec,$(CMD))

# SHORTCUTS

tests: phpstan paratest infection ## Runs the tests suites
