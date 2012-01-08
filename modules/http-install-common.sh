#!/bin/bash
# HTTP Install: Common Functions

# Check DotDeb
if check_repository_ni "dotdeb"; then
	# Print Warning
	warning "This module requires the DotDeb repository to be installed, please install it and run this module again!"
	# Continue Loop
	continue
fi

# Clean HTTP Config
echo -n "" > /usr/share/nginx/www/index.html
mv /etc/nginx/mime.types /etc/nginx/nginx.d/mime.conf
rm -rf /etc/nginx/conf.d/* /etc/nginx/sites-*
