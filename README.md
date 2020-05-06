# Plugin Tester

Simple Docker image for running WordPress Unit Tests for plugins. To run the tests for you plugin, from the plugin directory:

```
docker run --rm -v $PWD:/code humanmade/plugin-tester
```

The above assumes you have `phpunit/phpunit` specified as a Composer dependency of you plugin, and a `phpunit.dist.xml` in the plugin root.

Also, your `tests` directory in your plugin should include a `bootstrap.php` including at least the following:

```php
<?php
require '/wp-phpunit/includes/functions.php';

tests_add_filter( 'muplugins_loaded', function () {
	require dirname( __FILE__ ) . '/../s3-uploads.php';
} );

require '/wp-phpunit/includes/bootstrap.php';
```

## Code Coverage

Plugin Tester includes [pcov](https://github.com/krakjoe/pcov) for test coverage, which is natively supported by PHPUnit 8+.

WordPress requires PHPUnit 7, so slight adjustments need to be made to PHPUnit to fix compatibility. Plugin Tester will do this automatically for you, provided you have [pcov-clobber](https://github.com/krakjoe/pcov-clobber) installed via Composer:

```sh
composer require --dev pcov/clobber
```

You can then set up coverage in your `phpunit.dist.xml`, or use the command-line flags:

```sh
docker run --rm -v $PWD:/code humanmade/plugin-tester --coverage-text --whitelist inc/
```
