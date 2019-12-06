#!/bin/sh

set -eu

if [ "${WP_DOCKER:-}" != "1" ]; then
    >&2 echo "This script is for the Docker container init."
    exit 1
fi

composer install

composer wp-install

if [ -f init-docker.sh ]; then
    # Run the custom init if any
    ./init-docker.sh
fi

if [ -f "${WP_TT_INSTALL_DIR}/web/wp-config.php" ]; then
    >&2 echo "WP installed. You can access it from http://localhost:8080/ and run tests against it using ./docker/shell.sh"
    cd "${WP_TT_INSTALL_DIR}/web"
    exec wp server --host=0.0.0.0
else
    # Otherwise just keep the container running so it can be accessed with docker/shell.sh
    >&2 echo "Init ok! Start the shell in antoher terminal with ./docker/shell.sh"
    exec tail -f /dev/null
fi
