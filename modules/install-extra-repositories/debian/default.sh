#!/bin/bash
# Optimise Default Repositories

# Ask If Repositories Should Be Optimised
if question --default yes "Do you want to optimise the default repositories? (Y/n)"; then
	subheader "Optimising Default Repositories..."
	# Update Squeeze Repository
	echo "deb http://ftp.us.debian.org/debian/ squeeze main contrib non-free" > /etc/apt/sources.list
	# Update Squeeze Updates Repository
	echo "deb http://ftp.us.debian.org/debian/ squeeze-updates main contrib non-free" >> /etc/apt/sources.list
	# Update Squeeze Security Repository
	echo "deb http://security.debian.org/ squeeze/updates main contrib non-free" >> /etc/apt/sources.list
fi
