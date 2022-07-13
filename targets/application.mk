version: CMD=php -v 			## Displays the PHP version

version:
	$(call runDockerComposeExec,${CMD})
