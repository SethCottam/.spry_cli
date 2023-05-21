  ##############################################################################################
 ########  Spry CLI functions - START                                                  ########
##############################################################################################
#
# Spry CLI
# Shortcut - @spry
# Description - Core Spry CLI functions
# Author - Seth Cottam
# Dependencies - colors, format, finder
# Status - Operational

function spry() {
    # Example parent function

    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        local args="${@:2}"
    fi

	# If the string is not empty
	if [[ -n ${1} ]]; then
		local full_function="_spry_${1}"
		if [[ "$(whence ${full_function})" = "${full_function}" ]]; then
            # format success "Running ${0} ${1}"
			# Call the family_arg1 then pass all args >= arg position 2
            ${full_function} ${@:2}
		else
            format spry
            format error " does not support \"${1}\" as an argument"
			_spry_help
		fi
	else
        # Go to the spry custom root directory
        if [[ ${SPRY_MODE} == "development" ]]; then
            cd ${SPRY_CLI_ROOT}
        else 
            cd ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}
        fi
		_spry_help
	fi
}

##############################################################################################
####  Helper Child Functions (For Independant Shells)
##############################################################################################
# These should be included as helper functions with MOST independant shell scripts

# For the open and finder commands.
SPRY_SOURCE=${0:a}

function _spry_open() {
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
    local temp_source=$SPRY_SOURCE

    format info "Opening ${(P)temp_source} with ${ide}"
    ${ide} ${(P)temp_source}
}

##############################################################################################
####  Helper Child Functions (Standard)
##############################################################################################
# These should be included as helpers with MOST parent functions

function _spry_help() {
    # Formated Help using Finder function
    echo ""
    format spry
    format info " help"
    format casual "This is the framework for interfacing with scripts"
    # We only want to show all the SpryCLI children in development mode
    if [[ $SPRY_MODE == "development" ]]; then
        finder children spry $SPRY_SOURCE
    fi
    echo ""
    _spry_examples
    format debug1 "hist functions spry" "Shows a list of your previous usage examples"
    echo ""
}

function _spry_examples() {
    # List of usage examples
    format info "Command Examples:"
    format spry
    format debug1 " help" "help (You are here)"
    format spry
    format debug1 " status" "Check the Git status of Spry CLI from anywhere"
    format spry
    format debug1 " pull" "Perform a Git pull for Spry CLI from anywhere"
    format spry
    format debug1 " push" "Perform a Git push for Spry CLI from anywhere"
    format spry
    format debug1 " spryts" "Display s a list of all Spryts"
}

##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having

function _spry_refresh() {
    # Calling with arguments in ZSH will pass them onto the autoloader allowing switching between modes through a refresh
    # EXAMPLE: refresh development
    # EXAMPLE: refresh production

    local spry_cli_version_hash=$(_spry_generate_hash ${SPRY_CLI_ROOT_DIRECTORY} 2>&1)
    local spry_cli_custom_version_hash=$(_spry_generate_hash ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY} 2>&1)

    # If something is different in the code OR you're trying to load under a different mode
    # if [[ $spry_cli_version_hash != $SPRY_CLI_VERISON_HASH ]] || [[ $spry_cli_custom_version_hash != $SPRY_CLI_CUSTOM_VERISON_HASH ]] ||  [[ ${1} != ${SPRY_MODE} ]]; then
    if [[ $spry_cli_version_hash != $SPRY_CLI_VERISON_HASH ]] || [[ $spry_cli_custom_version_hash != $SPRY_CLI_CUSTOM_VERISON_HASH ]]; then

        echo -e "${INFO}Refreshing Spry CLI${RESET}"
        # Reloads this file so any new Spry or Spryt changes will be usable
        if [[ -n ${1} ]]; then
            . $SPRY_CLI_AUTOLOADER ${1}
        elif [[ -z ${SPRY_MODE} ]]; then
            . $SPRY_CLI_AUTOLOADER ${SPRY_MODE}
        else
            . $SPRY_CLI_AUTOLOADER
        fi

    else
        format info "This shell has already sourced the current files from" partial
        format spry partial
        format info " and ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/"
        # echo -e "${INFO}This shell has already sourced the current Spry CLI files${RESET}"
    fi
}

function _spry_generate_hash() {
    # This creates a hash of the directory (except for sepcified sub-folders) and contents for version checkings

    local exclusion_directory=${SPRY_CLI_ROOT}/system/faux_db/counters
    local directory=${SPRY_CLI_ROOT}
    

    # If the string is not empty
    if [[ -n ${1} ]]; then
        if [[ ${1} =~ ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY} ]]; then
            exclusion_directory="${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/file_storage/counters"
            directory="${1}"
        else
            exclusion_directory="${SPRY_CLI_ROOT}/system/faux_db/counters"
            directory="${SPRY_CLI_ROOT}"
        fi
    # else
    #     exclusion_directory="${SPRY_CLI_ROOT}/system/faux_db/counters"
    #     directory="${SPRY_CLI_ROOT}"
    fi
    
    # tar cfP - ${SPRY_CLI_ROOT} | md5  # Original that doesn't exclude
    tar cP --exclude=${exclusion_directory} -c ${directory} | md5
}

function _spry_status() {
    # Simple status check for git. This is for development.

    # Lets show the git status
    local result=$(git --git-dir $SPRY_CLI_ROOT/.git --work-tree $SPRY_CLI_ROOT status --ignored 2>&1)

    # for line in $result; do
    #   echo "Line: $line"
    # done

    # Two different options on how to approach it
    # while IFS= read -r line ; do echo $line; done <<< "$variable"
    # echo "$variable" | while IFS= read -r line ; do echo $line; done

    # Reads the variable line by line to prod
    # TODO: I don't like this. There should be a way to read directly from the variable
    echo $result | while IFS= read -r line; do

        # First Line
        if [[ ${line} =~ "On branch "  ]]; then
            # First line (Standard)

            # Add in an awesome SpryCLI logo (No end of line break) followed by the branch
            format spry partial 
            echo -n "(${SUCCESS}${line#"On branch "}${RESET}): "

        # Second Line
        elif [[ ${line} =~ "Your branch is up to date with"  ]]; then
            echo "${SUCCESS}${line#"Your branch "}${RESET}"  # Remove "Your branch " and display the rest"
        elif [[ ${line} =~ "Your branch is ahead "  ]]; then
            echo "${WARNING}${line#"Your branch "}${RESET}"  # Remove "Your branch " and display the rest
        elif [[ ${line} =~ "Your branch is behind "  ]]; then
            echo "${ERROR}${line#"Your branch "}${RESET}"  # Remove "Your branch " and display the rest

        # File Categories
        elif [[ ${line} =~ "Untracked files:"  ]] && [[ $SPRY_MODE != "development" ]]; then
            # We want to display they exist without differentiating them from the rest
            echo "${WARNING} There are additional untracked files${RESET}"
        elif [[ ${line} =~ "Ignored files:"  ]] && [[ $SPRY_MODE != "development" ]]; then
            # We want to display they exist without differentiating them from the rest
            echo "${WARNING} There are additional ignored files${RESET}"

        # regex="\t"
        # regex="^(Untracked$|Ignored//*)"
        # regex="^(develop$|release//*)"
        # tab=$(printf '\t')
        # regex="^(\s{*})"

        # Untracked files:
        #   (use "git add <file>..." to include in what will be committed)
        #     .gitignore
        #     test_file.txt


        # Files
        elif [[ ${line} =~ "modified:"  ]]; then
            echo " - ${WARNING}${line//$'\t'}${RESET}"  # Remove the leading tab and display the rest
        elif [[ ${line} =~ "deleted:"  ]]; then
            echo "${WARNING}$line${RESET}"  # Remove the leading tab and display the rest
        elif [[ ${line} =~ "new file:"  ]]; then
            echo "${WARNING}$line${RESET}"  # Remove the leading tab and display the rest
        elif [[ ${line} =~ "spryts/*"  ]]; then
            echo " - ${WARNING}ignored (Spryt): ${line//$'\t'}${RESET}"

        # A small portion of the REGEX NIGHTMARE. REGEX on ZSH NEED TO DIE!
        # elif [[ ${line} =~ '^[[:space:]]*' ]]; then # Everything
        # elif [[ ${line} =~ '^[[:space:]]{2}' ]]; then # Just the appropiate lines
        # elif [[ ${line} =~ '^[[:tab:]]{1}' ]]; then # Explodes
        # elif [[ ${line} =~ '^[[:blank:]]{1}' ]]; then # Just the appropiate lines (Start with space or tab)
        # elif [[ ${line} =~ '^[[:\t:]]{1}' ]]; then # Explodese
        # elif [[ ${line} =~ '^[[\t]]{1}' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[\t]{1}' ]]; then # NOTHING
        # elif [[ ${line} =~ '^\t{1}' ]]; then # NOTHING
        # elif [[ ${line} =~ '^\t{1}\S*' ]]; then # NOTHING
        # elif [[ ${line} =~ '^\t' ]]; then # NOTHING
        # elif [[ ${line} =~ '\t\t' ]]; then # Lines with 2 spaces and no obcious tabs
        # elif [[ ${line} =~ '\t' ]]; then # Almost Everything
        # elif [[ ${line} =~ '\\S' ]]; then NOTHING
        # elif [[ ${line} =~ '[^\\S]' ]]; then # Everything
        # elif [[ ${line} =~ '\\t' ]]; then # NOTHING
        # elif [[ ${line} =~ '[\\t]' ]]; then # ALMOST EVERYTHING
        # elif [[ ${line} =~ '^[\\t]' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[\t]{1}' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[\\t]{1}' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[[\t]]{1}' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[[:space:]]{1}[A-Z]*' ]]; then # ig (Start with space or tab)
        # elif [[ ${line} =~ '^[ \t]{1}[A-Z]*' ]]; then # HONORS the space but not the tab
        # elif [[ ${line} =~ '^[ ]{0}[A-Z]*' ]]; then # EVERYTHING
        # elif [[ ${line} =~ '^[ \t]{0}[A-Z]*' ]]; then # EVERYTHING
        # elif [[ ${line} =~ '^[\t]{0}[A-Z]*' ]]; then # Everything
        # elif [[ ${line} =~ '^[\t]{1}[A-Z]*' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[\s]{2}[A-Z]*' ]]; then # Tried all spaces 1-12 NONE worked
        # elif [[ ${line} =~ '^[\s]*[A-Z]*' ]]; then # EVERYTHING
        # elif [[ ${line} =~ '^[\s\s]{2}[A-Z]*' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[\s\s]{1}[A-Z]*' ]]; then # NOTHING
        # elif [[ ${line} =~ '^\s{1}[A-Z]*' ]]; then # NOTHING
        # elif [[ ${line} =~ '^\s\s[A-Z]*' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[\s,\t]{1}[A-Z]*' ]]; then # NOTHING
        # elif [[ ${line} =~ '^[\s,\t]*' ]]; then # EVERYTHING
        # elif [[ ${line} =~ '^[\t]*' ]]; then # Everything
        # elif [[ ${line} =~ '^[^\t]' ]]; then # Everything
        # elif [[ ${line} =~ '^' ]]; then
        # regex=$(tr)
        # regex='^[/ /]*'
        # elif [[ ${line} =~ $regex ]]; then # EXPLODES

        # Total hack workaround because REGEX on ZSH can't read tabs... I hate REGEX
        elif [[ ${line//$'\t'/'XXX'} =~ 'XXX' ]]; then
            echo " - ${ERROR}untracked:\t${line//$'\t'}${RESET}"
        # else
            # echo -e "${DEBUG2}$line${RESET}"
        fi
    done
}

function _spry_check() {
    # Turns the folder and it's contents into a hash as a simple version check
    tar cfP - ${SPRY_CLI_ROOT} | md5
}

function _spry_pull() {
    # Git pull from anywhere. This is for development.
    # TODO: This will eventually be replaced with an updater:
    #   - We'll probably need an installer to set up a git repo for your private stuff
    #   - We'll need a version controller/updater for Spryts that will add it's own files to a .gitignore in that folder!
    git -C ${SPRY_CLI_ROOT} pull
}

function _spry_push() {
    # Git push from anywhere. This is for development.
    git -C ${SPRY_CLI_ROOT} push
}

function _spry_fetch() {
    # Git push from anywhere. This is for development.
    git -C ${SPRY_CLI_ROOT} fetch
}

function _spry_spryts() {
    # Displays all spryts
    ls -la ${SPRY_CLI_ROOT}/spryts
}

function _spry_new() {
    # Create a new spryt
    # TODO: Provide questions and deafults to help walk through the process
    # TODO: Add things like new a call over to new spryt generation

    # Walk them through a creation

    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        local args="${@:2}"
    fi

    # If the string is not empty
    if [[ -n ${1} ]]; then
        local spry_new_function="_spry_new_${1}"
        if [[ "$(whence ${full_function})" = "${full_function}" ]]; then
            # format success "Running ${0} ${1}"
            # Call the family_arg1 then pass all args >= arg position 2
            ${spry_new_function} ${@:2}
        else
            format spry
            format error " does not support \"${1}\" as an argument"
            _spry_help
        fi
    else
        # Go to the spry directory
        cd $SPRY_CLI_ROOT
        _spry_help
    fi

}

function _spry_version() {
    cat $SPRY_CLI_ROOT/version.txt
}

# TODO: This needs to be moved to it's own file
function spry_new_spyt() {
    # Creation of a new spryt 

}



##############################################################################################
 ########  Spry CLI functions - END                                                    ########
  ##############################################################################################