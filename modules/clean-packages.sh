#!/bin/bash
# Clean: Packages

# Module Warning
warning "This module will remove all non-essential packages on this system, you have been warned!"
if ! question --default yes "Do you still want to run this module and purge all non-essential packages? (Y/n)" || [ $UNATTENDED = 1 ]; then
	# Skipped Message
	subheader "Skipping Module..."
	# Skip Module
	continue
fi

# Update Package Lists
subheader "Updating Package Lists..."
package_update

# Create Package List
subheader "Creating Package List..."

# Copy Base Package List
cp $MODULEPATH/$MODULE/$DISTRIBUTION/base $MODULEPATH/$MODULE/temp

# Detect OpenVZ
if [ -f /proc/user_beancounters ] || [ -d /proc/bc ]; then
	warning "Detected OpenVZ!"
# Detect vServer
elif [[ $(uname -a | grep "vserver") ]]; then
	warning "Detected vServer!"
else
	# Copy Hardware Package List
	cat $MODULEPATH/$MODULE/$DISTRIBUTION/base-hw >> $MODULEPATH/$MODULE/temp

	# Detect i686
	if [ $(uname -m) = "i686" ]; then
		warning "Detected i686!"
		# Append Platform Relevent Packages To Package List
		cat $MODULEPATH/$MODULE/$DISTRIBUTION/kernel-i686 >> $MODULEPATH/$MODULE/temp
	fi

	# Detect x86_64
	if [ $(uname -m) = "x86_64" ]; then
		warning "Detected x86_64!"
		# Append Platform Relevent Packages To Package List
		cat $MODULEPATH/$MODULE/$DISTRIBUTION/kernel-x86_64 >> $MODULEPATH/$MODULE/temp
	fi

	# Detect XEN PV i686
	if [ $(uname -r) = *xen* ] && [ $(uname -m) = "i686" ]; then
		warning "Detected XEN PV i686!"
		# Append Platform Relevent Packages To Package List
		cat $MODULEPATH/$MODULE/$DISTRIBUTION/kernel-xen-i686 >> $MODULEPATH/$MODULE/temp
	fi

	# Detect XEN PV x86_64
	if [ $(uname -r) = *xen* ] && [ $(uname -m) = "x86_64" ]; then
		warning "Detected XEN PV x86_64!"
		# Append Platform Relevent Packages To Package List
		cat $MODULEPATH/$MODULE/$DISTRIBUTION/kernel-xen-x86_64 >> $MODULEPATH/$MODULE/temp
	fi
fi

# Copy Custom Package List
cat $MODULEPATH/$MODULE/$DISTRIBUTION/custom >> $MODULEPATH/$MODULE/temp

# Sort Package List
sort -o $MODULEPATH/$MODULE/temp $MODULEPATH/$MODULE/temp

# Clean Packages
subheader "Cleaning Packages..."

# Clean Packages (Debian/Ubuntu)
if [ $DISTRIBUTION = "debian" ] || [ $DISTRIBUTION = "ubuntu" ]; then
	# Execute Twice To Ensure Packages Are Fully Cleaned
	for (( i = 1; i <= 2; i++ )); do
		# Clear DPKG Package Selections
		dpkg --clear-selections
		# Set Package Selections
		dpkg --set-selections < $MODULEPATH/$MODULE/temp
		# Get Selections & Set To Purge
		dpkg --get-selections | sed -e "s/deinstall/purge/" > $MODULEPATH/$MODULE/temp
		# Set Package Selections
		dpkg --set-selections < $MODULEPATH/$MODULE/temp
		# Update DPKG
		DEBIAN_FRONTEND=noninteractive apt-get -q -y dselect-upgrade 2>&1 | tee -a $MODULEPATH/$MODULE/log
	done
fi

# Run Post Install Commands
source $MODULEPATH/$MODULE/$DISTRIBUTION/post.sh

# Remove Temporary Package List
rm $MODULEPATH/$MODULE/log $MODULEPATH/$MODULE/temp

# Upgrade Any Outdated Packages
package_upgrade

# Clean Packages
package_clean

# Clean Package List
package_clean_list

# SSH Warning
warning "All SSH Servers have been uninstalled! Be sure to install an SSH server again using the modules provided (install-dropbear or install-ssh)!"
