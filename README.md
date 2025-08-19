# humanmade/plugin-tester

[![Docker Pulls](https://img.shields.io/docker/pulls/humanmade/plugin-tester)](https://hub.docker.com/repository/docker/humanmade/plugin-tester) [![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/humanmade/plugin-tester)](https://hub.docker.com/repository/docker/humanmade/plugin-tester)

Simple Docker image for running unit tests for WordPress plugins with support for multiple PHP versions.

To run the tests for your plugin, run this in your plugin directory:

```sh
docker run --rm -v "$PWD:/code" humanmade/plugin-tester
```

You will need `phpunit/phpunit` specified as a Composer dependency of your plugin. Additional arguments can be passed to PHPUnit on the CLI directly, e.g.:

```sh
docker run --rm -v "$PWD:/code" humanmade/plugin-tester --stop-on-error
```

## PHP and WordPress Version Support

This image supports multiple PHP versions (8.0, 8.1, 8.2, 8.3) and WordPress versions. You can specify a specific combination using the appropriate Docker tag:

- `humanmade/plugin-tester:latest` - PHP 8.0 with WordPress 6.8 (default)
- `humanmade/plugin-tester:php80-wp6.8` - PHP 8.0 with WordPress 6.8
- `humanmade/plugin-tester:php81-wp6.8` - PHP 8.1 with WordPress 6.8
- `humanmade/plugin-tester:php82-wp6.8` - PHP 8.2 with WordPress 6.8
- `humanmade/plugin-tester:php83-wp6.8` - PHP 8.3 with WordPress 6.8

For older WordPress versions, replace `wp6.8` with your desired version (e.g., `wp5.4`, `wp5.5`, `wp5.6`).

**Examples:**

```sh
# Test with PHP 8.1 and WordPress 6.8
docker run --rm -v "$PWD:/code" humanmade/plugin-tester:php81-wp6.8

# Test with PHP 8.3 and WordPress 5.6
docker run --rm -v "$PWD:/code" humanmade/plugin-tester:php83-wp5.6
```

## Configuration

To configure PHPUnit, place a `phpunit.xml.dist` in the plugin root. You can alternatively use the command line arguments for PHPUnit for simpler tests.

Typically your `tests` directory in your plugin should include a `bootstrap.php` including at least the following:

```php
<?php
require '/wp-phpunit/includes/functions.php';

tests_add_filter( 'muplugins_loaded', function () {
	require dirname( __FILE__ ) . '/../your-plugin-entry-point.php';
} );

require '/wp-phpunit/includes/bootstrap.php';
```

## Continuous Integration with Travis

For Travis, the following minimal configuration will get your tests running:

```yaml
services:
  - docker

before_script:
  - composer install

script:
  - docker run --rm -v "$PWD:/code" humanmade/plugin-tester
```

We recommend also [caching the vendor directory](https://docs.travis-ci.com/user/caching/#arbitrary-directories):

```yaml
cache:
  timeout: 1000
  directories:
    - vendor
```


## Code Coverage

Plugin Tester includes [pcov](https://github.com/krakjoe/pcov) for test coverage, which is natively supported by PHPUnit 8+.

WordPress requires PHPUnit 7, so slight adjustments need to be made to PHPUnit to fix compatibility. Plugin Tester will do this automatically for you, provided you have [pcov-clobber](https://github.com/krakjoe/pcov-clobber) installed via Composer:

```sh
composer require --dev pcov/clobber
```

You can then set up coverage in your `phpunit.xml.dist`, or use the command-line flags:

```sh
docker run --rm -v "$PWD:/code" humanmade/plugin-tester --coverage-text --whitelist inc/
```
