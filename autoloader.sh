  ##############################################################################################
 ########  Autoloader - START                                                          ########
##############################################################################################
#
# Autoloader
# Shortcut: @dev_settings
# Description - Global Settings for Spry Development
# Author - Seth Cottam
# Status - Pending


# TODO: Might want to consider creating an Autoloader settings or pass through variables
#	https://stackoverflow.com/questions/39768712/how-to-pass-arguments-to-a-script-invoked-by-source-command
#	source ./test.sh a 'b c'

# TODO: Should wrap some if statements based on ENV variables
# TODO: Might also want to create a sly spry cli

SPRY_CLI_AUTOLOADER=${0:a}
SPRY_CLI_ROOT=${0:h}

# Ensures that the required global var SPRY_CLI_CUSTOM_ROOT_DIRECTORY is set. Does not verify the directory!
if [[ -n ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY} ]]; then
	export SPRY_CLI_CUSTOM_ROOT_DIRECTORY="${HOME}/spry_cli_custom"
	# ecbo "SpryCLI Custom directory set to the default path: ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}"
	
else
	# echo "SpryCLI Custom directory set to a custom path: ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}"''
fi


if [[ -n ${1} ]]; then
	# Development Mode - Purely for developing the Spry CLI
	if [[ ${1} == "development" || ${1} == "Development" ]]; then
		SPRY_MODE="development"
		SPRY_VERBOSE=true
		source ${SPRY_CLI_ROOT}/system/motd.sh
		source ${SPRY_CLI_ROOT}/system/master_controller.sh
	# Production Mode
	elif [[ ${1} == "production" || ${1} == "Production" ]]; then
		SPRY_MODE="production"
		SPRY_VERBOSE=false
		source ${SPRY_CLI_ROOT}/system/motd.sh
		source ${SPRY_CLI_ROOT}/system/master_controller.sh
	# Verbose Mode - Like production, but with more details
	elif [[ ${1} == "verbose" || ${1} == "Verbose" ]]; then
		SPRY_MODE="verbose"
		SPRY_VERBOSE=true
		source ${SPRY_CLI_ROOT}/system/motd.sh
		source ${SPRY_CLI_ROOT}/system/master_controller.sh
	# Fast Dev Mode
	elif [[ ${1} == "fast" || ${1} == "Fast" ]]; then
		# This is a temporary mode that is not intended to work beyond a single reload.
		SPRY_MODE="fast"
		SPRY_VERBOSE=false
		source ${SPRY_CLI_ROOT}/system/motd.sh
		source ${SPRY_CLI_ROOT}/system/master_controller.sh
		# Revert back to development mode for subsequent reloads
		SPRY_MODE="development" 
	# Malformeed requeset
	else
		# TODO: built this out
		echo "That's not a valid argument. Try \"production\", \"verbose\", or \"fast\" during your sourcing in your ~/.zshrc or ~/.bashrc file."
		echo "Example: \"source /Users/your_user/.spry_cli/autoloader.sh production\"" 
	fi
else
	if [[ -z ${SPRY_MODE} ]]; then
		SPRY_MODE="production"
	fi
	source ${SPRY_CLI_ROOT}/system/motd.sh
	source ${SPRY_CLI_ROOT}/system/master_controller.sh
fi

# Create a hash of the directory for loading checks
# TODO: This is not available until after the first successful load
if [[ $(type _spry_generate_hash) =~ "is a shell function" ]]; then
	SPRY_CLI_VERISON_HASH=$(_spry_generate_hash ${SPRY_CLI_ROOT_DIRECTORY})
	SPRY_CLI_CUSTOM_VERISON_HASH=$(_spry_generate_hash ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY})
fi

##############################################################################################
 ########  Autoloader - END                                                            ########
  ##############################################################################################

