  ##############################################################################################
 ########  Spryts Family function - START                                              ########
##############################################################################################
#
# Spryts
# Shortcut - @spryts
# Description - Spryts management tool
# Author - Seth Cottam
# Dependencies - colors, format, finder
# Status - Work in Progress

function spryts() {
    # Spryts parent function

    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        local args="${@:2}"
    fi

    local family="spryts"

	# If the string is not empty
	if [[ -n ${1} ]]; then
		local full_function="_${family}_${1}"
		if [[ "$(whence ${full_function})" = "${full_function}" ]]; then
            format success "Running ${0} ${1}"
			# Call the family_arg1 then pass all args >= arg position 2
            $full_function ${@:2}
		else
            format error "${family} does not support \"${1}\" as an argument"
			_${family}_help
		fi
	else
		_${family}_help
	fi

    # Cleanup and/or Garbage collection
    # unset args
}

##############################################################################################
####  Helper Child Functions (For Independant Shells)
##############################################################################################
# These should be included as helper functions with MOST independant shell scripts

# For the open and finder commands.
SPRYTS_SOURCE=${0:a}

function _spryts_open() {
    # Opens the file in it's current location

    # Open the current file with the command for opening the IDE of choice
    if [[ -n ${1} ]]; then
        local ide=${1}
    elif [[ -n ${IDE} ]]; then
        local ide=${IDE}  #  set as an Environment Variable
    else
        local ide="vim"
    fi

    # TODO: Could not make this work without setting a varaible. Needs to be refactored
    # NOTE: This does not work UNLESS It's called through the parent function NO DIRECT CALL!
    temp_source=${${family}:u}_SOURCE

    format info "Opening ${(P)temp_source} with ${ide}"
    ${ide} ${(P)temp_source}

    # Cleanup and/or Garbage collection (because sourced files retain variables in the shell)
    # unset ide temp_source
}

##############################################################################################
####  Helper Child Functions (Standard)
##############################################################################################
# These should be included as helpers with MOST parent functions

function _spryts_help() {
    # Formated Help using Finder function
    echo ""
    format info "${(C)family} help"
    format casual "This function family in an example for other function families"
    finder children $family $SPRYTS_SOURCE
    echo ""
    _${family}_examples
    format debug1 "Previous Usage" "hist functions ${family}"
    echo ""
}

function _spryts_examples() {
    # List of usage examples
    format debug1 "${(C)family} Help" "${family} help"
    format debug1 "${(C)family} Open" "${family} open OR ${family} open vim"
    format debug1 "${(C)family} Thing" "${family} thing"
}

##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having

function _spryts_thing() {
    # An Example child function
	echo -e "Arguments"
	echo -e "\$0 " $0
	echo -e "\$1 " $1
	echo -e "\$2 " $2
	echo -e "\$3 " $3
	echo -e "\$4 " $4
    format success "You ran the ${family} thing function"
}

##############################################################################################
 ########  Spryts Family function - END                                               ########
  ##############################################################################################