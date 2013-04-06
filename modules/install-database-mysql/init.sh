#!/bin/bash
# Install (Database): MySQL

# Install HTTP Common Functions
module-install-http-common

# Package List Update Question
package_update_question

# Copying Configuration
subheader "Copying Configuration..."
mkdir -p /etc/mysql/conf.d/
cp -r $MODULEPATH/$MODULE/mysql/conf.d/* /etc/mysql/conf.d/

# Install Package
subheader "Installing Package..."
package_install mysql-server

# Set Password
subheader "Setting Password..."
if [ $UNATTENDED = 1 ]; then
	# Stop Daemon
	daemon_manage mysql stop
	
	# Start MySQL Server
	mysqld_safe --background --skip-grant-tables

	# Sleep
	sleep 2

	# Set Password
	mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('$(read_var_module root_password)') WHERE User='root'; FLUSH PRIVILEGES;"

	# Stop Daemon
	killall mysqld
fi

# Check PHP
if check_package "php5-fpm" || check_package "php-fpm"; then
	subheader "Installing PHP MySQL Package..."
	if [ $DISTRIBUTION = "centos" ]; then
		package_install php-mysql
	else
		package_install php5-mysql
	fi
fi

# Stop Daemon
subheader "Stopping Daemon..."
if [ $DISTRIBUTION = "centos" ]; then
	daemon_manage mysqld stop
else
	daemon_manage mysql stop
fi

# Copy Configuration
subheader "Copying Configuration..."
cp -r $MODULEPATH/$MODULE/mysql/* /etc/mysql/

# Start Daemon
subheader "Starting Daemon..."
if [ $DISTRIBUTION = "centos" ]; then
	daemon_manage mysqld start
else
	daemon_manage mysql start
fi
