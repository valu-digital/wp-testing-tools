#!/bin/sh

set -eu

composer wp-install

>&2 echo "WP installed. You can access it from http://localhost:8080/ and run tests against it using docker/shell.sh"

# Start WordPress server with wp-cli for functional, acceptantce and manual
# testing. The WP instance can be accessed from http://localhost:8080/
cd .wp-install/web
set -x
exec wp server --host=0.0.0.0