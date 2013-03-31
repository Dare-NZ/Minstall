#!/bin/bash
# Functions For Managing Package Cleaning/Updating

# Set Package List Update Variable
PACKAGE_LIST_UPDATE=0

# Package List Update Question
function package_update_question() {
	# Check If Package List Update Has Been Run Previously
	if [ $PACKAGE_LIST_UPDATE = 0 ]; then
		# Ask Question
		if question --default yes "Do you want to update the package list? (Y/n)" || [[ $UNATTENDED = 1 && $(read_var minstall__package_update) = 1 ]]; then
			# Update Package Lists
			package_update
		fi

		# Set Package List Update Variable
		PACKAGE_LIST_UPDATE=1
	fi
}
