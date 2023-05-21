  ###############################################################################################
 ########  Counter Functions - START                                                    ########
###############################################################################################
#
# Counter Functions
# Description - For counting usage
# Author - Seth Cottam
# Version - 1.0.0
# Status - Operational

# TODO: Need to wrap this into the master controller so that it grabs all of the things, a few have been added manually.

SPRY_CORE_FUNCTIONS_LIST=(spry spryts stats finder refresh packager updater)
SPRY_SPRYT_FUNCTIONS_LIST=(1p admind ammo audio cars example example_python koniag kube linked mem memory moregood ohmyzsh pythony raw_blytz requirements sec security speedtest todo blytz)

# TODO: May want to split it into different kinds of commands
#	helps, spry, spryts

function preexec() { 
	# ZSH built-in option to allow something to be run whenever <enter> is pressed by the user but before the command itself is run


	# Get only the first command sent through
	local command=$(echo ${1} | cut -d' ' -f1)
	# echo ${command}
	# check for help

	# echo "PREEXEC Capture= ${1}"

	local alias_core_check=$(grep -rl "alias ${1}=" --exclude-dir="installation_files" ${SPRY_CLI_ROOT_DIRECTORY})
	local alias_custom_check=$(grep -rl "alias ${1}=" --exclude-dir="installation_files" ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY})

	# Check for Alia functions
	if [[ -n ${alias_core_check} || -n ${alias_custom_check} ]]; then
		_counter_increment_alias
		_counter_increment
	# Check for Core functions
	elif [[ ${SPRY_CORE_FUNCTIONS_LIST[(ie)${command}]} -le ${#SPRY_CORE_FUNCTIONS_LIST} ]]; then
		if [[ ${1} =~ " help| help |_help|_help_" ]]; then
			echo '(preexec) SpryCLI help function detected and counted'
			_counter_increment_help
			_counter_increment
		else
			# echo '(preexec) SpryCLI core function detected and counted'
			_counter_increment_core
			_counter_increment
		fi
	# Check for Spryt Functions
	elif [[ ${SPRY_SPRYT_FUNCTIONS_LIST[(ie)${command}]} -le ${#SPRY_SPRYT_FUNCTIONS_LIST} ]]; then
		# Note: we might want to not include a help for Spryts, but I do like it. Maybe reconsider later
		if [[ ${1} =~ " help| help |_help|_help_" ]]; then
			# echo '(preexec) SpryCLI help function detected and counted'
			_counter_increment_help
			_counter_increment
		else
			# echo '(preexec) SpryCLI Spryt function detected and counted'
			_counter_increment_spryt
			_counter_increment
		fi
	fi
}

function counter() {
    # Example parent function

    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        local args="${@:2}"
    fi

	# If the string is not empty
	if [[ -n ${1} ]]; then
		local full_function="_counter_${1}"
		if [[ "$(whence ${full_function})" = "${full_function}" ]]; then
			# Call the family_arg1 then pass all args >= arg position 2
            ${full_function} ${@:2}
		else
            format error "counter does not support \"${1}\" as an argument"
			_counter_help
		fi
	else
		_counter_help
	fi
}


##############################################################################################
####  Helper Child Functions
##############################################################################################

# For the open and finder commands.
SPRY_COUNTER_SOURCE=${0:a}  # TODO: All Spry core sources sould be prepended with $SPRY_...


function _counter_help() {
    # Formated Help using Finder function

    echo ""
    format info "Counter help"
    format casual "This function family in an example for other function families"
    # echo -e "${(U)family}_SOURCE = ${(P)temp_source}"
    finder functions counter $SPRY_COUNTER_SOURCE
    echo ""
    _counter_examples
    echo "\n"
}

function _counter_examples() {
    # List of usage examples
    # TODO: Need to finish this list
    format debug1 "Counter Help" "counter help"
}


##############################################################################################
####  Child Functions
##############################################################################################

# TODO: Need to clean this whole thing up!

function _counter_increment() {
	# Increment the usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/counter.txt)
	echo $((${result}+1)) > ${SPRY_CLI_COUNTER_DIRECTORY}/counter.txt
}

function _counter_increment_help() {
	# Increment the "help" usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/help.txt)
	echo $((${result}+1)) > ${SPRY_CLI_COUNTER_DIRECTORY}/help.txt
}

function _counter_increment_core() {
	# Increment the "core" usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/core.txt)
	echo $((${result}+1)) > ${SPRY_CLI_COUNTER_DIRECTORY}/core.txt
}

function _counter_increment_spryt() {
	# Increment the "spryt" usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/spryt.txt)
	echo $((${result}+1)) > ${SPRY_CLI_COUNTER_DIRECTORY}/spryt.txt
}

function _counter_increment_alias() {
	# Increment the "alias" usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/alias.txt)
	echo $((${result}+1)) > ${SPRY_CLI_COUNTER_DIRECTORY}/alias.txt
}


function _counter_check() {
	# Check the usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/counter.txt)
	echo ${result}
}

function _counter_check_help() {
	# Check the "hrlp" usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/help.txt)
	echo ${result}
}

function _counter_check_core() {
	# Check the "core" usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/core.txt)
	echo ${result}
}

function _counter_check_spryt() {
	# Check the "spryt" usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/spryt.txt)
	echo ${result}
}

function _counter_check_alias() {
	# Check the "alias" usage counter

	local result=$(cat ${SPRY_CLI_COUNTER_DIRECTORY}/alias.txt)
	echo ${result}
}

# TODO: Go through the history to track the number of times commands have been useds and add those to the existing history ... might only be ZSH or OhMyZSH history compatible... can't remember if the default includes a count for each row
# history | grep -e '^[ ]*[0-9]*[ ]*[_]*spry[_]*[A-Za-z0-9]*[_]*[A-Za-z]*[_]*[A-Za-z]*'
# history | grep -e '^[ ]*[0-9]*[ ]*[_]*spry[_]*[A-Za-z0-9]*[_]*[A-Za-z]*[_]*[A-Za-z]*' | wc -l
# history | grep -e '^[ ]*[0-9]*[ ]*[_]*spry[_]*[_A-Za-z0-9]*' | wc -l  # This one is shorter, and more scalable


###############################################################################################
 ########  CLI Development functions - END                                              ########
  ###############################################################################################