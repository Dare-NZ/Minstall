#!/bin/bash
# HTTP Configure: MySQL Database Server

# Check Package
if ! check_package "mysql-server"; then
	# Print Warning
	warning "This module requires the mysql-server package to be installed, please install it and run this module again!"
	# Shift Variables
	shift
	# Continue Loop
	continue
fi

# Configure MySQL For Minimal Memory Usage
if question --default yes "Do you want to configure MySQL for minimal memory usage? (Y/n)" || [ $(read_var_module minimal_memory) = 1 ]; then
	subheader "Adding Configuration..."
	cp -r $MODULEPATH/$MODULE/mysql/conf.d/lowmem.cnf /etc/mysql/conf.d/
# Configure MySQL For Normal Memory Usage
else
	subheader "Removing Configuration..."
	rm /etc/mysql/conf.d/lowmem.cnf > /dev/null 2>&1
fi

# Disable InnoDB Database Engine
if question --default yes "Do you want to disable InnoDB? (Y/n)" || [ $(read_var_module disable_innodb) = 1 ]; then
	subheader "Disabling InnoDB..."
	cp -r $MODULEPATH/$MODULE/mysql/conf.d/innodb.cnf /etc/mysql/conf.d/
	subheader "Removing InnoDB Files..."
	rm -f /var/lib/mysql/ib* > /dev/null 2>&1
# Enable InnoDB Database Engine
else
	subheader "Enabling InnoDB..."
	rm /etc/mysql/conf.d/innodb.cnf > /dev/null 2>&1
fi

# Attended Mode
if [ $UNATTENDED == 0 ]; then
	# Secure Installation Script
	if question --default yes "Do you want to run MySQL's secure installation script? (Y/n)"; then
		subheader "Running Script..."
		mysql_secure_installation
	fi
fi

# Restart Daemon
subheader "Restarting Daemon..."
daemon_manage mysql restart
