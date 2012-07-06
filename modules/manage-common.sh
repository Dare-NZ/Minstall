#!/bin/bash
# Manage: Common Functions

#####################
## Check Functions ##
#####################

# Check If Array Empty
manage-check-array() {
	if [ $USER = 0 ]; then
		# Print Message
		error "No users in user array. Aborting."
		# Exit Loop
		break
	fi
}

# Check User
manage-check-user() {
	if [ ! -d /home/$USER ]; then
		# Print Message
		echo "Invalid user ($USER)."
		# Continue In Array
		continue
	fi
}

#####################
## Setup Functions ##
#####################

# HTTP Folder Setup
manage-folder() {
	subheader "Adding HTTP Folder..."
	mkdir -p /home/$USER/http/{common,hosts,logs,private}
	subheader "Changing HTTP Permissions..."
	chown -R $USER:$USER /home/$USER/http
	find /home/$USER/http -type d -exec chmod 770 {} \;
	subheader "Adding User To HTTP Group..."
	gpasswd -a www-data $USER
}

# Reset Permissions
manage-reset-permissions() {
	subheader "Changing User File Permissions..."
	chmod -R o= /home/$USER
	chown -R $USER:$USER /home/$USER
}
