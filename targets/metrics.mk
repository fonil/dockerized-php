phpmetrics: CMD=./vendor/bin/phpmetrics --junit=./.reports/coverage/junit.xml --report-html=./.reports/metrics ./app

phpmetrics:
	$(call runDockerComposeExec,$(CMD))

# SHORTCUTS

metrics: phpmetrics ## Generates a report with relevant metrics
