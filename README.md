# WP Testing Tools

Testing WordPress plugins is PITA. The wp-browser project makes it possible
but because it requires a working WordPress installation to be usable and
setting up one is very laborious. This project aims to automate that part.

It contains following components:

- A Composer installable script (`wp-install`) for installing WordPress into
  Docker containers, Github Actions or where ever.
- Reuseable Docker enviroment for local testing and debugging with xdebug
- Github Action Workflow for continuous integration
- Example plugin on how to setup all this

The example plugin under the `plugin` directory. Lets go through it file by
file and explain the purpose of each file.

### `composer.json`

This is the main composer file which make your plugin installable using
Composer. Define any library dependencies of your plugin here but do not add
other plugins here since your plugin users might want to install those by
other means.

In it we define this package as a dev requirement under `"require-dev"` with
`"valu/wp-testing-tools": "^0.2.0"`.

But most interesting part is the `"wp-install"` script under `"scripts"`:

    wp-install --full --wp-composer-file composer.wp-install.json --env-file .env

This `wp-install` tool is provided by this package it actually does the
WordPress installation using wp-cli.

It takes few arguments

- `--full`: Make full installation for functional and acceptance testing.
  This can be omitted when just doing wpunit tests.
- `--wp-composer-file`: The `composer.json` file to use when installing
  WordPress
- `--env-file` The .env file to use

### `composer.wp-install.json`

Since we cannot add WP plugin dependencies to the main `composer.json` we can
add them here and they get installed and activated to the testing
installation automatically.

### `.env`

This file is copied from `.env.github` or `.env.docker` depending on the
environment. It contains the database credentials and the installation
location for WordPress. Checkout their content for more information.

### `codeception.dist.yml`

The Codeception config. If you added WP plugins in `composer.wp-install.json`
you must add them to the `modules.config.WPLoader.plugins` and
`modules.config.WPLoader.activatePlugins` sections to be activated during
wpunit testings.

### `tests/`

The directory containing the test. Please refer to the Codeception and
wp-browser documention.

### `docker/`

This directory contains the Docker enviroment configuration. You as the
plugin author are not supposed to edit anything under this directory. Any
customizations you need should be doable in `.env.docker` and other
extensions points. If you need some help customizing the Docker enviroment
feel free to open an issue!

This way the Docker enviroment is upgradeable. Just copy the latest version
from this repository when you want to update the latest version.

The docker directory exposes two scripts for working with the enviroment:

- `./docker/compose.sh`: This is a small wrapper over `docker-compose` which
  used to starts the Docker enviroment.
- `./docker/shell.sh`: Once the environment is setup you can use this script
  to enter the testing shell to run `codecept` commands

### `plugin.php` and `src/`

The `plugin.php` is the entry point for your plugin and the `src/` directory
will contain the actual plugin implementation.
