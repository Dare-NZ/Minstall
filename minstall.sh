#!/bin/bash
# Loads libraries and runs specified modules.

# Loop Through Libraries
for file in libraries/*.sh; do
	# Source Scripts
	source $file
done

# Check Distribution
if [ $DISTRIBUTION = 'none' ]; then
	# Print Distribution Not Supported Message
	error "Your distribution is unsupported."
fi

# Load Distribution Specific Libraries
for file in libraries/platforms/*.$DISTRIBUTION.sh; do
	# Source Scripts
	source $file
done

# Loop Through Parameters
while [ $# -ge 1 ]; do
	# Check Parameters Against Known Scripts
	case $1 in
		# Help Function
		help)
			# Load Help Script
			source modules/script-help.sh
			# Exit
			exit
		;;
		# Module Listing Function
		modules)
			# Load Module Listing Script
			source modules/script-modules.sh
			# Exit
			exit
		;;
		# Load Scripts
		*)
			# Check If Module Exists
			if [ -f modules/$1.sh ]; then
				# Load Module
				source modules/$1.sh
			# Module Doesn't Exist
			else
				# Ask If User Wants To Abort
				if question --default yes "Module $1 not found. Do you want to abort? (Y/n)"; then
					# Print Message & Exit
					error "Aborted."
				fi
			fi
		;;
	esac
	# Continue
	shift
done
