  ##############################################################################################
 ########  Stats Functions - START                                                     ########
##############################################################################################
#
# Stats
# Shortcut - @stats
# Description - Program for tracking stats
# Author - Seth Cottam
# Dependencies - colors, format, finder
# Status - Operational

# Shellcheck - `shellcheck --shell=bash stats.sh`
# shellcheck disable=SC2211
# shellcheck disable=SC2154  # For allowing bash usage
# shellcheck disable=SC2086  # Ingore for conveince

function stats() {
    # Stats parent function

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
		full_function="_${family}_${1}"
		if [[ "$(whence ${full_function})" = "${full_function}" ]]; then
			# Call the family_arg1 then pass all args >= arg position 2
            $full_function "${@:2}"
		else
            format error "${family} does not support \"${1}\" as an argument"
			_${family}_help
		fi
	else
		 _${family}_help
	fi

    # Cleanup and/or Garbage collection
    unset family full_function args
}

##############################################################################################
####  Helper Child Functions (For Independent Shells)
##############################################################################################
# These should be included as helper functions with MOST independent shell scripts

# For the open and finder commands.
STATS_SOURCE=${0:a}

function _stats_open() {
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
    echo "temp_source = ${temp_source}"
    echo "P temp_source = ${(P)temp_source}"

    format info "Opening ${(P)temp_source} with ${ide}"
    ${ide} ${(P)temp_source}
}

##############################################################################################
####  Helper Child Functions (Standard)
##############################################################################################
# These should be included as helpers with MOST parent functions

function _stats_help() {
    # Formated Help using Finder function
    echo ""
    format info "${(C)family} help"
    format casual "This function family in an stats for other function families"
    finder functions $family $STATS_SOURCE
    echo ""
    _${family}_examples
    format debug1 "Previous Usage" "hist functions ${family}"
    echo ""
}

function _stats_examples() {
    # List of usage ecamples
    format debug1 "${(C)family} Help" "${family} help"
    format debug1 "${(C)family} Open" "${family} open OR ${family} open vim"
    format debug1 "${(C)family} Thing" "${family} thing"
}

##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having

function _stats_aliases() {
    # Count of the Aliases in a directory

    if [[ -n ${1} ]]; then
        local directory=${1}
    else
        local directory="." # Current directory
    fi

    # grep (Global Regular Expression Print) -or ("o" Prints only the matching part of the lines. "r" recursive search)
    # ^ (Beginning of line) alias (Character match) [A-Za-z0-9] (Any uppercase/lowercase letter, any number) \+ (one or more occurances)
    # $url (Path to the directory that needs to be recusrively searched)
    # wc (Word Count) -l (Get a count of lines)
    # tr (TRansliterate) -d ' ' (Delete characters mathcing ' ')
    grep -or '^alias [A-Za-z0-9_-]\+=' $directory | wc -l | tr -d ' '
}

function _stats_constants() {
    # Count of the Constants in a directory

    if [[ -n ${1} ]]; then
        local directory=${1}
    else
        local directory="." # Current directory
    fi

    # grep (Global Regular Expression Print) -or ("o" Prints only the matching part of the lines. "r" recursive search)
    # [A-Z_-] (Any uppercase letter or underscore) \+ (one or more occurances)
    # $url (Path to the directory that needs to be recusrively searched)
    # wc (Word Count) -l (Get a count of lines)
    # tr (TRansliterate) -d ' ' (Delete characters mathcing ' ')
    grep -or '[A-Z_]\+=' $directory | wc -l | tr -d ' '
}

function _stats_todo() {
    # Count of the TODOs in a directory

    if [[ -n ${1} ]]; then
        local directory=${1}
    else
        local directory="." # Current directory
    fi

    # grep (Global Regular Expression Print) -or ("o" Prints only the matching part of the lines. "r" recursive search)
    # TODO (Character match)
    # $url (Path to the directory that needs to be recusrively searched)
    # wc (Word Count) -l (Get a count of lines)
    # tr (TRansliterate) -d ' ' (Delete characters mathcing ' ')
    grep -or 'TODO' $directory | wc -l | tr -d ' '
}

function _stats_functions() {
    # Count of the ZSH/Bash functions in a directory

    if [[ -n ${1} ]]; then
        local directory=${1}
    else
        local directory="." # Current directory
    fi

    # grep (Global Regular Expression Print) -or ("o" Prints only the matching part of the lines. "r" recursive search)
    # [A-Za-z0-9] (Any uppercase/lowercase letter, any number, underscore, or dash) \+ (one or more occurances) [\s] (Space) * (zero or more times) "()" (Character match)
    # $url (Path to the directory that needs to be recusrively searched)
    # wc (Word Count) -l (Get a count of lines)
    # tr (TRansliterate) -d ' ' (Delete characters mathcing ' ')
    grep -or '[A-Za-z0-9_-]\+[\s]*()' $directory | wc -l | tr -d ' '
}

function _stats_comments() {
    # Count of the Comments in a directory

    if [[ -n ${1} ]]; then
        local directory=${1}
    else
        local directory="." # Current directory
    fi

    # grep (Global Regular Expression Print) -or ("o" Prints only the matching part of the lines. "r" recursive search)
    # "#" (Character match) [A-Za-z0-9] (Any uppercase/lowercase letter, any number) \+ (one or more occurances)
    # $url (Path to the directory that needs to be recusrively searched)
    # wc (Word Count) -l (Get a count of lines)
    # tr (TRansliterate) -d ' ' (Delete characters mathcing ' ')
    # TODO: If the directory is missing it retunrs: grep: spryts: No such file or directory
    grep -or '# [A-Za-z0-9]\+' $directory | wc -l | tr -d ' '
}

function _stats_lines() {
    # Counts of  the number of lines per file in a directory

    if [[ -n ${1} ]]; then
        local directory=${1}
    else
        local directory="." # Current directory
    fi

    # find (Search command) . "r" recursive search)
    # $url (Path to the directory that needs to be recusrively searched)
    # -name '*.sh' (for all files ending in .sh)
    # -o (allows for adding another -name arg fpr ,ultiple extentions)
    # xargs (eXtended ARGuments to pass multiple args into the following command)
    # wc (Word Count) -l (Get a count of lines)
    # tr (TRansliterate) -s ' ' (Squeeze multiple characters matching ' ' into a single character)
    find $directory -name '*.sh' -o -name '*.py' | xargs wc -l | tr -s ' ' 
}

function _stats_usage() {
    # WIP - Gives stats on the usage of functions and aliases

    # Most accurate for Oh-My-ZSH history:
    # 5749  exit
    # 5750  git push
    # 5751  spry push
    # EXPLAINATION: ^ = start of the line, \s = space, \w+ = word with one or more characters, \s = space, ${1} = the argument variable, (\$|\s) = End of line OR space
    history | grep -Ec "^\s\w+\s+${1}(\$|\s)" | xargs
}

function _stats_spryts() {
    # WIP - Go through each spryt to get then get the usage of each of the commands

    # Load every shell file in the spryts (plugins) directory
    
    if [[ -n ${1} ]]; then
        local spryts=(${1}/*.sh)
    else
        local spryts=(${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts/*.sh)
    fi

    for shell_spryt in $spryts; do
        local filename=${shell_spryt:t}
        local name=${filename:gs/".sh"/""}
        finder children ${name} ${shell_spryt}
    done

    # Load every python file in the spryts (plugins) directory
    # local spryts=(${SPRY_CLI_ROOT_DIRECTORY}/spryts/*.py)
    # for py_spryt in $spryts; do
    #     load_py_source $py_spryt $load_source_mode
    # done
}

function _stats_shell_spryts() {
    if [[ -n ${1} ]]; then
        local spryts=(${1}/*.sh)
    else
        local spryts=(${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts/*.sh)
    fi
    
    local shell_count=${#spryts[@]}
    echo ${shell_count}
}

function _stats_python_spryts() {
    if [[ -n ${1} ]]; then
        local spryts=(${1}/*.py)
    else
        local spryts=(${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts/*.py)
    fi

    local python_count=${#spryts[@]}
    echo ${python_count}
}

function _stats_families() {
    # WIP 
    # NOTE: a family is a function with at least one child function

    if [[ -n ${1} ]]; then
        local spryts=(${1}/*.sh)
    else
        local spryts=(${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts/*.sh)
    fi

    # Load every shell file in the spryts (plugins) directory
    local families_count=0
    for shell_spryt in $spryts; do
        local filename=${shell_spryt:t}
        local name=${filename:gs/".sh"/""}
        result=$(finder parents ${shell_spryt} 2>&1)

        # IFS='\n' read -a parents <<< "${result}"  # Bash
        for parent (${(f)result}) 
            if [[ ${parent} =~ "\(\)" ]]; then
                let families_count++
            fi
    done
    echo ${families_count}
}

function _stats_children() {
    # WIP - Go through each spryt to get then get the usage of each of the commands
    # NOTE: a child function is a function with a parent

    if [[ -n ${1} ]]; then
        local spryts=(${1}/*.sh)
    else
        local spryts=(${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts/*.sh)
    fi

    # Load every shell file in the spryts (plugins) directory
    local children_count=0
    for shell_spryt in $spryts; do
        local filename=${shell_spryt:t}
        local name=${filename:gs/".sh"/""}
        finder children ${name} ${shell_spryt}
        let children_count++
    done
    # echo "children_count = ${children_count}"

    # Load every python file in the spryts (plugins) directory
    # local spryts=(${SPRY_CLI_ROOT_DIRECTORY}/spryts/*.py)
    # for py_spryt in $spryts; do
    #     load_py_source $py_spryt $load_source_mode
    # done

    echo "WIP"
}

function _stats_tests() {

}

function _stats_table() {
    # TODO: Move the stats table from user_init to here
}

function _stats_git() {
    # Shows git shortstats for the current author
    # TODO: Need to break this up into multiple functions and format it... but it's cool

    git log --shortstat --author="$(git config user.name)" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6; delta+=$4-$6; ratio=deleted/inserted} END {printf "Commit stats:\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", files, inserted, deleted, delta, ratio }' -
}


##############################################################################################
####  Study and Notes
##############################################################################################
# For putting stuff in that's way too raw to deserve a function, that may be helpful later

# Log with brief stats for the current user
# git log --shortstat --author="$(git config user.name)"

# Show all the files changes, lines added, lines deleted, and tootal lines changed for the current user
# git log --shortstat --author="$(git config user.name)" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6; delta+=$4-$6; ratio=deleted/inserted} END {printf "Commit stats:\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", files, inserted, deleted, delta, ratio }' -

# Show the log with the colored + and - for the changes
# git log --stat --author="$(git config user.name)"

# Show the log with the colored + and - for the changes but limit the representation with to 10 chracters 
#   - each represents 10 percent of the total changes in the commit with a + or -
# git log --stat --stat-graph-width=10 --author="$(git config user.name)"

##############################################################################################
 ########  Stats Functions - END                                                       ########
  ##############################################################################################