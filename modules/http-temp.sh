#!/bin/bash
# HTTP: Temp

# Package List Update Question
package_update_question

# Install Package
subheader "Installing Package..."
package_install temp

# Copy Configuration
subheader "Copying Configuration..."
cp -r $MODULEPATH/$MODULE/* /etc/

# Restart Daemon
subheader "Restarting Daemon..."
invoke-rc.d temp restart

# Package List Clean Question
package_clean_question
