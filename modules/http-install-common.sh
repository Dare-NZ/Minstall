#!/bin/bash
# HTTP Install: Common Functions

# Check DotDeb
if ! check_repository "dotdeb"; then
	# Print Warning
	warning "This module requires the DotDeb repository to be installed, please install it and run this module again!"
	# Shift Variables
	shift
	# Continue Loop
	continue
fi

# Clean HTTP Config
mv /etc/nginx/mime.types /etc/nginx/nginx.d/mime.conf > /dev/null 2>&1
rm -rf /etc/nginx/sites-* /etc/php5/fpm/pool.d/www.* > /dev/null 2>&1
