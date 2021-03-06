#!/bin/sh
# Enter the build system and run all operations
cd /path/to/the/build/system/ || exit;
php bin/magento deploy:mode:set default
git pull origin master
composer install
rm -rf var/cache/* var/page_cache/* var/view_preprocessed/* pub/static/frontend/* pub/static/adminhtml/* pub/static/_cache/* pub/static/deployed_version.txt generated/code/* generated/metadata/*
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy en_US de_DE -f -a frontend --theme Magento/luma --jobs=4
php bin/magento setup:static-content:deploy en_US de_DE -f -a adminhtml --jobs=4
php bin/magento deploy:mode:set production --skip-compilation

# Upload to the live system, upgrade and sync
cd /path/to/the/production/system/ || exit;
php bin/magento maintenance:enable
php bin/magento deploy:mode:set default
git pull origin master
composer install
git checkout .htaccess
rm -rf var/cache/* var/page_cache/* var/view_preprocessed/* pub/static/frontend/* pub/static/adminhtml/* pub/static/_cache/* pub/static/deployed_version.txt generated/code/* generated/metadata/*
rm -rf var/cache/* var/page_cache/* var/view_preprocessed/* pub/static/frontend/* pub/static/adminhtml/* pub/static/_cache/* pub/static/deployed_version.txt generated/code/* generated/metadata/*
rm -rf var/cache/* var/page_cache/* var/view_preprocessed/* pub/static/frontend/* pub/static/adminhtml/* pub/static/_cache/* pub/static/deployed_version.txt generated/code/* generated/metadata/*
php bin/magento setup:upgrade
rsync -ah /path/to/the/build/system/generated/ generated/
rsync -ah /path/to/the/build/system/var/view_preprocessed/ var/view_preprocessed/
rsync -ah /path/to/the/build/system/pub/static/ pub/static/
php bin/magento deploy:mode:set production --skip-compilation
php bin/magento cache:clean
php bin/magento cache:flush
php bin/magento maintenance:disable
# Protection from turning off the caches
php bin/magento cache:enable
