<?php

$dir = dirname(DRUPAL_ROOT);
$settings['container_yamls'][] = $dir . '/docroot/sites/development.services.yml';
$settings['update_free_access'] = TRUE;
$settings['hash_salt'] = 'drupal9_test_halt';

/**
 * Show all error messages, with backtrace information.
 *
 * In case the error level could not be fetched from the database, as for
 * example the database connection failed, we rely only on this value.
 */
$config['system.logging']['error_level'] = 'verbose';

/**
 * Disable CSS and JS aggregation.
 */
$config['system.performance']['css']['preprocess'] = FALSE;
$config['system.performance']['js']['preprocess'] = FALSE;

$config['system.file']['path']['temporary'] = '/tmp';

$databases['default']['default'] = array (
  'database' => 'drupal',
  'username' => 'drupal',
  'password' => '3.1415926',
  'prefix' => '',
  'host' => 'localhost',
  'port' => '33067',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
//$settings['config_sync_directory'] = DRUPAL_ROOT . '/../config/sync';
