# Plugin Tester

Simple Docker image for running WordPress Unit Tests for plugins. To run the tests for you plugin, from the plugin directory:

```
docker run --rm humanmade/plugin-tester $PWD:/code
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
