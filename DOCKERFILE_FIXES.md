# Dockerfile fixes log

This file tracks the fixes made to the Dockerfiles for pecl installation issues.

## Issues Fixed

### PHP 8.2 (Dockerfile.php82)
- Fixed pecl command from `pecl82` to `pecl`
- Added pear configuration before pecl install

### PHP 8.3 (Dockerfile.php83) 
- Fixed pecl command from `pecl83` to `pecl`
- Added pear configuration before pecl install

## Root Cause
In Alpine Linux, the pecl command naming is inconsistent across PHP versions. While some versions use version-specific names like `pecl82`, others just use `pecl`. Additionally, pear needs to be configured with the correct php.ini path before pecl can be used effectively.