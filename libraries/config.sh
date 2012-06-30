#!/bin/bash
# Functions For Config Parsing

# INI Variable Tester
read_var() {
	# Check If Variable Exists
	if [[ $(eval "echo \${INI__$1}") = "" ]]; then
		# Echo False
		echo 0
	else
		# Echo Variable
		eval "echo \${INI__$1}"
	fi
}

# INI Variable Tester
read_var_module() {
	# Check If Variable Exists
	if [[ $(eval "echo \${INI__$(safe_string $MODULE)__$1}") = "" ]]; then
		# Echo False
		echo 0
	else
		# Echo Variable
		eval "echo \${INI__$(safe_string $MODULE)__$1}"
	fi
}

# Remove Invalid Characters From Section Names
safe_string() {
	# Replace Dash With Underscore
	echo "$1" | tr - _
}
