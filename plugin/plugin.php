<?php
/**
 * Plugin Name: Example Plugin
 * Plugin URI: https://github.com/valu-digital/wp-testing-tools
 * Description: Example plugin
 * Author: You?
 * Version: 0.1.0
 *
 * @package example
 */

 // Use the local autoload if not using project wide autoload
 if (!\class_exists('\Example\Example')) {
    require_once __DIR__ . '/vendor/autoload.php';
 }

\Example\Example::init();