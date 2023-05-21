  ##############################################################################################
 ########  Go To Family function - START                                               ########
##############################################################################################
#
# Go To 
# Shortcut - @goto
# Description - Locates and goes to any function within
# Author - Seth Cottam
# Dependencies - colors, format, finder
# Version - 2.0.1
# Status - Operational

# TODO: Build a duplicates check funciton

function goto() {
    # Example parent function

    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi

    if [[ -n ${IDE} ]]; then
        local ide=${IDE}  #  set as an Environment Variable
    else
        local ide="vim"
    fi

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
            # Normally we'd show an error on family arguments, but in this case we'll dive right into a search
            # format error "${family} does not support \"${1}\" as an argument"
			#_${family}_help

           _${family}_find ${@:1}

		fi

	else
		_${family}_help
	fi

    # Cleanup and/or Garbage collection once everything else has been run
    unset args
}

##############################################################################################
####  Helper Child Functions (For Independant Shells)
##############################################################################################
# These should be included as helper functions with MOST independant shell scripts

# For the open and finder commands.
GOTO_SOURCE=${0:a} 

function _goto_open() {
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

function _goto_help() {
    # Formated Help using Finder function
    local temp_source=${${family}:u}_SOURCE

    echo ""
    format info "${(C)family} help"
    format casual "This function family in an example for other function families"
    echo -e "${(U)family}_SOURCE = ${(P)temp_source}"
    finder children $family ${(P)temp_source}
    echo ""
    # _${family}_examples
    format debug1 "Previous Usage" "hist functions ${family}"
    echo ""
}

function _goto_examples() {
    # List of usage examples
    format debug1 "${(C)family} Help" "${family} help"
    format debug1 "${(C)family} Open" "${family} open OR ${family} open vim"
    format debug1 "${(C)family} Thing" "${family} thing"
}

##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having

function _goto_find() {

    # Try to find the @ tag (Exclude the installation files)
    local result=$(grep -nr --exclude-dir=${SPRY_CLI_INSTALLAION_FILES_DIRECTORY} "@${1}" {$SPRY_CLI_ROOT,$SPRY_CLI_CUSTOM_ROOT_DIRECTORY})
    # format debug1 "${(C)family} Open" "${family} open OR ${family} open vim"

    # If no @ tag match exists try to find a matching function
    if [[ ! -n ${result} ]]; then

        # TODO this should all be in one or more child functions
        # result=$(grep -n "${1}()" $filepath | cut -f1 -d: 2>&1)

        # Try to find a parent function matching the value
        result=$(grep -nr  --exclude-dir=${SPRY_CLI_INSTALLAION_FILES_DIRECTORY} "${1}()" {$SPRY_CLI_ROOT,$SPRY_CLI_CUSTOM_ROOT_DIRECTORY})

        # These should be switched to assume the error unless there is a success
        if [[ ! -n ${result} ]]; then
            format error "Unable to locate a matching tag @${1} or a function ${1}() anywhere within ${SPRY_CLI_ROOT}/"
        else
            # TODO: Finish this! Example: goto refresh
            echo "DEBUGGING: Hit the found it else"
            local result_sections=("${(@s/:/)result}") # @ modifier
            echo $result
            echo $result_sections[0]
            echo $result_sections[1]
            local filepath=$result_sections[1]
            local line_number=$result_sections[2]

            # format success "Found ${1}() on line $line_number of $filepath"

            # Open to the file to the correct line
            # ${ide} ${filepath}:${line_number}
            _goto_open $ide $filepath $line_number
        fi
    else
        # TODO this should all be in one or more child functions
        # Found the tag
        local result_sections=("${(@s/:/)result}") # @ modifier
        local filepath=$result_sections[1]
        local line_number=$result_sections[2]

        format success "Found @${1} on line $line_number of $filepath"

        # Open to the file to the correct line
        # ${ide} ${filepath}:${line_number}
        _goto_open $ide $filepath $line_number
    fi

}

function _goto_open() {
    # Open the file to the line of the @tag
	# TODO this should all be in one or more child functions

    if [[ -n ${1} ]] && [[ -n ${1} ]] && [[ -n ${3} ]]; then
        local ide=${1}
        local filepath=${2}
        local line_number=${3}
        # [IDE] [FILEPATH]:[LINE_NUMBER]
        format success "Opening $line_number in $filepath in $ide"
        ${ide} ${filepath}:${line_number}
    else
        format error "Requires arg1 = ide, arg2 = "
        format casual "Example: goto sublime "
    fi
}

##############################################################################################
 ########  Go To Family function - END                                                 ########
  ##############################################################################################