# WP Testing Tools

WordPress testing for everyone! 🤗

Testing WordPress plugins is PITA. The wp-browser project makes it possible
but it requires a working WordPress installation to be used. Unfortunately
setting up one is very laborious which is why many especially smaller plugins
omit tests completely. So the humble mission of this project is make that
barrier go away completely so there would be no excuses to not write tests
for WordPress plugins! 💪

This project contains following components:

- A Composer installable script (`wp-install`) for installing WordPress into
  Docker containers, Github Actions or where ever.
- Reuseable Docker enviroment for local testing and debugging with xdebug
- Github Action Workflow for continuous integration
- Example plugin on how to setup all this

Projects using this setup

- https://github.com/valu-digital/wp-graphql-cache
- https://github.com/valu-digital/wp-graphql-polylang
- https://github.com/valu-digital/wp-graphql-lock
- https://github.com/valu-digital/wp-graphql-offset-pagination

## Starting

For new projects you can just copy all files from `plugin/` and rename the
"example" strings.

For existing projects you can install this using composer

    composer require --dev valu/wp-testing-tools
    # You'll want the wp-browser too
    composer require --dev lucatume/wp-browser

After installing you can copy the test files to your plugin with

    ./vendor/bin/wptt-configure

## Plugin files

The example plugin is under the `plugin/` directory. Lets go through it file
by file and explain the purpose of each.

### `composer.json`

This is the main composer file which makes your plugin installable using
Composer. Define any library dependencies of your plugin here but do not add
other plugins here since your plugin users might want to install those by
other means.

In it we define this package as a dev requirement under `"require-dev"` with
`"valu/wp-testing-tools": "^0.4.0"`.

But the most interesting part is the `"wp-install"` script under `"scripts"`:

    wp-install --full --wp-composer-file composer.wp-install.json --env-file .env

This `wp-install` tool is provided by this package and it actually does the
WordPress installation using wp-cli.

It takes few arguments

- `--full`: Make full installation for functional and acceptance testing.
  This can be omitted when just doing wpunit tests.
- `--wp-composer-file`: The `composer.json` file to use when installing
  WordPress
- `--env-file`: The .env file to use
- The `--wp-composer-file` and `--env-file` arguments are optional and the
  example is just showing the defaults
- For more information see `--help` or the [source](https://github.com/valu-digital/wp-testing-tools/blob/master/tools/wp-install).

### `composer.wp-install.json`

Since we cannot add WP plugin dependencies to the main `composer.json` we can
add them here and they get installed & activated to the testing installation
automatically.

### `.env`

This file is copied from `.env.github` or `.env.docker` depending on the
environment. It contains the database credentials and the installation
location for WordPress. Checkout their content for more information.

### `codeception.dist.yml`

The Codeception config. You must configure your plugin entry point (among
with the ones defined in `composer.wp-install.json`) to the
`modules.config.WPLoader.plugins` and
`modules.config.WPLoader.activatePlugins` sections to be activated during
wpunit tests.

### `tests/`

The directory containing the tests. Please refer to the Codeception and
wp-browser documention.

### `docker/`

This directory contains the Docker enviroment configuration. You as the
plugin author are not supposed to edit anything under this directory. Any
customizations you need should be doable in `.env.docker` and other
extensions points. If you need some help customizing the Docker enviroment
feel free to open an issue!

This way the Docker enviroment is upgradeable. Just copy the latest version
from this repository when you want to update to the latest version.

The docker directory exposes a `run` script for working with the enviroment:

- `./docker/run compose`: This is a small wrapper over `docker-compose` which
  used to starts the Docker enviroment.
- `./docker/run shell`: Once the environment is setup you can use this script
  to enter the testing shell to run `codecept` commands
- `./docker/run update`: When you update the `valu/wp-testing-tools` composer
  package this command can be used to update the Docker environment.

The plugin directory will be mounted to `/app` so you can make changes from
the host and they are visible immediately to the container.

### `plugin.php` and `src/`

These are opinionated take on how to structure WordPress plugins with
Composer Autoloading. If you don't care about that or are adapting existing
plugin you can just remove these files along with the `"autoload"` config
from `composer.json`.

But if you do it's highly recommend that you read the comments in
[plugin.php](/plugin/plugin.php). It contains information on how to ship your
plugin properly to both composer and non-composer users.

## Customizing the WP install for Functiontal Tests

You can add a `tests/wptt-wp-config.php` which is required in the install's
`wp-config.php` if it is readable.

You can also add `tests/wptt-mu-plugin.php` which is loaded as a mu-plugin in
the install if it is readable.

## Using XDebug with Docker

### Visual Studio Code

Install the [PHP Debug][php] extension.

1. Add launch config to `.vscode/launch.json` or to the global config:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Docker: PHP Listen for XDebug",
      "type": "php",
      "request": "launch",
      "port": 9000,
      "pathMappings": {
        "/app": "${workspaceFolder}"
      }
    }
  ]
}
```

2. Start the container with `./docker/run compose`

3. From the VSCode `DEBUG AND RUN` view start the `Docker: PHP Listen for XDebug` launch config

4. Add break points

5. Start testing shell `./docker/run shell` and run the tests with `codecept run wpunit`

Profit!

[remote]: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
[php]: https://marketplace.visualstudio.com/items?itemName=felixfbecker.php-debug

### PHPStorm

The IDEKEY is "wptt".

Please contribute?
