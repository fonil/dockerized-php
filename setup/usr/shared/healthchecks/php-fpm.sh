#!/bin/bash

set -e

output=$(SCRIPT_NAME=/status/ping SCRIPT_FILENAME=/status/ping REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000 | tail -1)

if [ "$output" = "pong" ]; then
    exit 0
else
    exit 1
fi
