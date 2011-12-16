#!/bin/bash
# Installs Dropbear SSH Server/Client

# Print Header
header "Installing Dropbear Server/Client"

# Package List Update Question
package_update_question

# Install Package
subheader "Installing Package..."
package_install dropbear

# Update Configuratio
cp -r install-dropbear/* /etc/

# Install OpenSSH SFTP Support
subheader "Installing OpenSSH SFTP Support..."
source modules/install-ssh.sh

# Remove OpenSSH Daemon
subheader "Removing OpenSSH Daemon..."
daemon_remove ssh

# Restart Daemon
subheader "Restarting Daemon..."
/etc/init.d/dropbear restart

# Package List Clean Question
package_clean_question
