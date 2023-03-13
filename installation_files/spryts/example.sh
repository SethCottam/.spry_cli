  ##############################################################################################
 ########  Mini-README - START                                                         ########
##############################################################################################
#
# This is an example for how to build of a family of functions as an individual plugin
#
# Alternatively, you can also add a mew .sh file with a single function and call it by name
#   from the command line. Example: cars.sh could be called 
#
# It really can be that simple
#
# Enjoy!!!
#
#
# Usage instructions (replace "example" with the name your function):
# - From the command line, terminal, or similiar tool type `example`, `example help`, 
#       `example examples`, `example thing value1 value2 value3`, etc 
# 
# Optional Usage Instructions
# - To load into your Command Line outside of SpryCLI just run `source ./example.sh`
# - For single runs without CLI loading
#       - add `example` at the bottom of this script then
#       - From the command line, terminal, or similiar tool type `chmod +x ./example.sh`
#           (this makes it executable as a single script)
#       - From the command line, terminal, or similiar tool type `./example.sh`
#           (repeat this last step each additional time you want to run it)
#
##############################################################################################
 ########  Mini-README - END                                                           ########
  ##############################################################################################


  ##############################################################################################
 ########  Example Family Functions - START                                            ########
##############################################################################################
#
# Example Title
# Shortcut - @example
# Description - Example description of the thing and purpose
# Author - Seth Cottam
# Dependencies - colors, format, finder
# Version - 4.0.1
# Status - Operational


function example() {
    # Example parent function

    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi

    # This only needs to be set if the autodetect doesn't work for your system
    # local family="example"

    # Autodetect family
    if [[ -n ${FUNCNAME[0]} ]]; then
        local family=$(FUNCNAME[0])
    elif [[ -n ${funcstack[1]} ]]; then
        local family=${funcstack[1]}
    else
        format error "Can't detect the function name, please set family=${family} manually"
    fi

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
    unset args
}

##############################################################################################
####  Helper Child Functions (For Independent Shells)
##############################################################################################
# These should be included as helper functions with MOST independent shell scripts

# For self identifying it's location
EXAMPLE_SOURCE=${0:a}

function _example_open() {
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
    local temp_source=${${family}:u}_SOURCE

    format info "Opening ${(P)temp_source} with ${ide}"
    ${ide} ${(P)temp_source}

    # Cleanup and/or Garbage collection (because sourced files retain variables in the shell)
    # unset ide temp_source
}

##############################################################################################
####  Helper Child Functions (Standard)
##############################################################################################
# These should be included as helpers with MOST parent functions

# NOTE: You only need one of the two following help functions, have them fight to the death
function _example_help() {
    # Simple Help function
    echo ""
    echo -e "${INFO}${family} help${RESET}"
    echo -e "${CASUAL}This function family in an example for other function families${RESET}"
    echo -e "${INFO}Our Massive index... of a couple functions:${RESET}"
    grep --color=always -A 1 "${family}_[A-Za-z0-9]*[_]*[A-Za-z]*[(][)]" ~/.bashrc
    echo -e "${INFO}Previous Usage = hist functions ${family}${RESET}"
    echo ""
}

function _example_help() {
    # Formated Help using Finder function

    local temp_source=${${family}:u}_SOURCE

    echo ""
    format info "${(C)family} help"
    format casual "This function family in an example for other function families"
    # echo -e "${(U)family}_SOURCE = ${(P)temp_source}"
    finder functions $family ${(P)temp_source}
    echo ""
    # _${family}_examples
    format debug1 "Previous Usage" "hist functions ${family}"
    echo ""
}

function _example_examples() {
    # List of usage examples
    format debug1 "${(C)family} Help" "${family} help"
    format debug1 "${(C)family} Open" "${family} open OR ${family} open vim"
    format debug1 "${(C)family} Thing" "${family} thing"
}

##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having

function _example_thing() {
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
####  Built-in Script Trigger
##############################################################################################

# example  # Remove the first "#" to enable trigger

##############################################################################################
 ########  Example Family Functions - END                                              ########
  ##############################################################################################