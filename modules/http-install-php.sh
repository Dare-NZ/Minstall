#!/bin/bash
# HTTP Install: PHP Application Server

# Common Functions
source $MODULEPATH/http-install-common.sh

# Package List Update Question
package_update_question

# Install Package
subheader "Installing Package..."
package_install php5-fpm

# Ubuntu PHP Suhosin Install
if [ $DISTRIBUTION = "ubuntu" ]; then
	subheader "Installing PHP Suhosin Extension..."
	package_install php5-suhosin
fi

# Check MySQL
if check_package "mysql-server"; then
	subheader "Installing PHP MySQL Package..."
	package_install php5-mysql
fi

# Copy Configuration
subheader "Copying Configuration..."
rm /etc/php5/fpm/pool.d/www.conf
cp -r $MODULEPATH/$MODULE/php5/* /etc/php5/

# Restart Daemon
subheader "Restarting Daemon..."
daemon_manage php5-fpm restart

# Package List Clean Question
package_clean_question
