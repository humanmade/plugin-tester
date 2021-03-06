# humanmade/plugin-tester

[![Docker Pulls](https://img.shields.io/docker/pulls/humanmade/plugin-tester)](https://hub.docker.com/repository/docker/humanmade/plugin-tester) [![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/humanmade/plugin-tester)](https://hub.docker.com/repository/docker/humanmade/plugin-tester)

Simple Docker image for running unit tests for WordPress plugins.

To run the tests for your plugin, run this in your plugin directory:

```sh
docker run --rm -v "$PWD:/code" humanmade/plugin-tester
```

You will need `phpunit/phpunit` specified as a Composer dependency of your plugin. Additional arguments can be passed to PHPUnit on the CLI directly, e.g.:

```sh
docker run --rm -v "$PWD:/code" humanmade/plugin-tester --stop-on-error
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
