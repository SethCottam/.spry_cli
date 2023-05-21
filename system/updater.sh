  ##############################################################################################
 ########  Updater - START                                                             ########
##############################################################################################
#
# Example Title
# Shortcut - @updater
# Description - Example description of the thing and purpose
# Author - Seth Cottam
# Dependencies - colors, format, finder
# Status - Operational

function updater() {
    # Example parent function

    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi

    # This only needs to be set if the autodetect doesn't work for your system
    # family="example"

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
####  Helper Child Functions (For Independant Shells)
##############################################################################################
# These should be included as helper functions with MOST independant shell scripts

# For the open and finder commands.
UPDATER_SOURCE=${0:a}

function _updater_open() {
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

function _updater_help() {
    # Formated Help using Finder function
    echo ""
    format info "${(C)family} help"
    format casual "This is the${RESET} $(format spry partial)"
    finder children $family $EXAMPLE_SOURCE
    echo ""
    _${family}_examples
    format debug1 "Previous Usage" "hist functions ${family}"
    echo ""
}

function _updater_examples() {
    # List of usage examples
    format debug1 "${(C)family} Help" "${family} help"
    format debug1 "${(C)family} Open" "${family} open OR ${family} open vim"
    format debug1 "${(C)family} Thing" "${family} thing"
}

##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having

function _updater_check() {
    # These git functions run from anywhere
    local fetch=$(git --git-dir $SPRY_CLI_ROOT/.git --work-tree $SPRY_CLI_ROOT fetch 2>&1)
    local result=$(git --git-dir $SPRY_CLI_ROOT/.git --work-tree $SPRY_CLI_ROOT status --ignored 2>&1)

     echo $result | while IFS= read -r line; do

        # First Line
        if [[ ${line} =~ "On branch "  ]]; then
            # First line (Standard)

            # Add in an awesome SpryCLI logo (No end of line break) followed by the branch
            format spry partial 
            
        # Second Line
        elif [[ ${line} =~ "Your branch is up to date with '"  ]]; then
            # We just want to colorize, not fully formant
            echo "${SUCCESS} is on the most current version${RESET}"
        elif [[ ${line} =~ "Your branch and 'origin/master' have diverged"  ]]; then
            # We just want to colorize, not fully formant
            local version=$(spry version)
            echo "${WARNING} is on an older version${RESET}${CASUAL}(${RESET}${WARNING}${version}${CASUAL}${CASUAL}(${RESET}"
            format casual "Update using the following command" partial
            format command "updater update"
        fi
    done
}

function _updater_update() {
    # One last safety catch
    local result=$(git remote -v 2>&1)

    # Check to see if the remote repo is the production
    if [[ ${result} =~ "https://github.com/SethCottam/.spry_cli.git" ]] || [[ ${result} =~ "git@github.com:SethCottam/.spry_cli.git" ]]; then
        format info "Updating the Spry CLI"
        git reset --hard origin/master
        format info "You are on version $(spry version)"
    else
        format error "This repo is not tied to the GitHub Spry CLI repo"

    fi
}

##############################################################################################
 ########  Example Family function - END                                               ########
  ##############################################################################################