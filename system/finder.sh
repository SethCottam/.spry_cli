  ##############################################################################################
 ########  Finder functions - START                                                    ########
##############################################################################################
#
# Finder
# Shortcut - @finder
# Description - Finding various things
# Author - Seth Cottam
# Version - 1.1.0
# Status - Work in progress

# For self identifying it's location
FINDER_SOURCE=${0:a}

function finder() {
    # ~$ finder prefix file
    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi

    # If the string is not empty
    if [[ -n ${1} ]]; then
        full_function="_finder_$1"
        if [[ "$(whence ${full_function})" = "${full_function}" ]]; then
            # Let's keep this silent
            # formmat success "You're not an idiot after all. That command actually exists!"
            $full_function $@
        else
            echo ""
            format error "finder does not support \"${1}\" as an argument"
            _finder_help
        fi
    else
        _finder_help
    fi
}

function _finder_functions() {
    # Finds all functions that start with the passed in value(s) as an argument (ex. finder functions mem)
    # Example: finder functions mem ~/bin/tools/mem.sh
    # Example: finder functions mem

    # Allows the passing of a file
    if [[ -f ${3} ]]; then
        local file=${3}
    else
        # TODO: This file is non-operational
        format warning "No file provided so we're defaulting to master single file"
        local file=$HOME/$CLI_MASTER_FILE
    fi

    format info "Finding functions prepended with \"${2}\" in ${file}"

    # Finds all functions whether or not they are prepended with function and/or _
    local result=$(grep --color=always -A 1 "^[function ]*[_]*${2}[_]*[A-Za-z0-9]*[_]*[A-Za-z]*[(][)]" ${file} 2>&1)

    local replace="function"
    local replacement=""

    i=0
    while read line; do

        if [[ ${i} == 0 ]]; then
            # This is the function
            local found_function=${line}
            # local found_function=${found_function%"function "}  # BASH
            local found_function=${found_function:gs/function /""}  # ZSH
        elif [[ ${i} == 1 ]] && [[ ${line} =~ "#"  ]]; then
            # This is potentially the comment line
            echo "${found_function: : -2} ${line}"
            # echo "${found_function} ${line}"
        elif [[ ${i} == 1 ]]; then
            # This is potentially the comment line
            echo "${found_function: : -2}"
        elif [[ ${i} == 2 ]]; then
            # this is the -- splitter
            i=-1
        fi

        ((i=i+1))

    done <<< "$result"

    # Cleanup and/or Garbage collection
    unset line
}


function _finder_functions_all() {
    # Finds all functions that start with the passed in value(s) as an argument (ex. finder functions all)
    # Example: finder functions_all ~/spry_cli/spryts/unsorted_functions.sh
    # Example: finder functions_all

    # Allows the passing of a file
    if [[ -f ${2} ]]; then
        local file=${2}
    else
        # TODO: This file is non-operational
        format warning "No file provided so we're defaulting to master single file"
        local file=$HOME/$CLI_MASTER_FILE
    fi

    format info "Finding functions in ${file}"

    # Finds all functions whether or not they are prepended with function and/or _
    local result=$(grep --color=always -o "^[function ]*[_A-Za-z0-9]*[_]*[A-Za-z]*[(][)]" ${file} 2>&1)

    # TODO: Incorperate this
    # local replace="function "
    # local replacement=""

    i=0
    while read line; do

        local found_function=${line}
        # local found_function=${found_function%"function "}  # BASH
        local found_function=${found_function:gs/function /""}  # ZSH
        # echo ${found_function}
        echo ${found_function/\(\)/}  # Remove the brackets

    done <<< "$result"

    # Cleanup and/or Garbage collection
    unset line
}

function _finder_children() {
    # Finds all child functions that start with the passed in value(s) as an argument (ex. finder children mem)
    # Example: finder functions mem ~/spry_cli/spryts/mem.sh
    # Example: finder functions mem
    # TODO: Cleanup these examples

    # Allows the passing of a file
    if [[ -f ${3} ]]; then
        local file=${3}
    else
        format warning "No file provided so we're defaulting to master single file"
        local file=$HOME/$CLI_MASTER_FILE
    fi

    format info "Finding \"${2}\" children functions within ${file}"

    # Finds all functions prepended with _ whether or not they are prepended with function or not
    local result=$(grep --color=always -A 1 "^[function ]*_${2}_[A-Za-z0-9]*[_]*[A-Za-z]*[(][)]" ${file} 2>&1)

    local replace="function"
    local replacement=""

    i=0
    while read line; do

        if [[ ${i} == 0 ]]; then
            # This is the function line
            # Remove everything after the ()
            local found_function=$(echo "${line}" | egrep -o '^[^{]+')
            local found_function=${found_function:gs/function _/""}  # ZSH
        elif [[ ${i} == 1 ]] && [[ ${line} =~ "#"  ]]; then
            # This is the comment line
            #echo "${found_function: : -2} ${line}"
            echo "${found_function} ${line}"
        # elif [[ ${i} == 1 ]]; then
            # This is just the first line of the function. If they want a comment then they need the #
            # echo "${found_function: : -2}"
        elif [[ ${i} == 2 ]]; then
            # this is the -- splitter from grep so we remove it
            i=-1
        fi

        ((i=i+1))

    done <<< "$result"

    # Cleanup and/or Garbage collection
    unset line
}

function _finder_parent() {
    # WIP - Finds all functions that start with the passed in value(s) as an argument (ex. finder parent mem)
    # Example: finder functions mem ~/bin/tools/mem.sh
    # Example: finder functions mem
    # TODO: Cleanup these examples
    # NOTE: A parent function without any children is just a normal

    # Allows the passing of a file
    if [[ -f ${3} ]]; then
        local file=${3}
    else
        # TODO: This file is non-operational
        format warning "No file provided so we're defaulting to master single file"
        local file=$HOME/$CLI_MASTER_FILE
    fi

    format info "Finding \"${2}\" parent functions within ${file}"

    # Finds all functions prepended with _ whether or not they are prepended with function or not
    local result=$(grep --color=always "^[function ]*${2}*[(][)]" ${file} 2>&1)
    echo result

    # Verify it has at least one child
    local child_count=$(grep --color=always -A 1 "^[function ]*[_]*${2}_[A-Za-z0-9]*[_]*[A-Za-z]*[(][)]" ${file} 2>&1)
 
    # If there is at least one result with at least one child
    if [[ -n ${result} ]] && [[ -n ${child_count} ]]; then
        local replace="function"
        local replacement=""
        i=0
        while read line; do
            # echo "line: ${line}"
            if [[ ${i} == 0 ]]; then
                # This is the function
                local found_function=${line}
                local found_function=${found_function:gs/function /""}  # ZSH
                # echo -e "found_function: ${found_function}"
                echo "${found_function: : -1}"
            fi

            ((i=i+1))
        done <<< "$result"

        # Cleanup and/or Garbage collection
        unset line
    fi
}

function _finder_parents() {
    # WIP - Finds all functions that start with the passed in value(s) as an argument (ex. finder functions mem)
    # Example: finder functions mem ~/bin/tools/mem.sh
    # Example: finder functions mem
    # TODO: Cleanup these examples
    # NOTE: A parent function without any children is just a normal

    # Allows the passing of a file
    if [[ -f ${2} ]]; then
        local file=${2}
    else
        # TODO: This file is non-operational
        format warning "No file provided so we're defaulting to master single file"
        local file=$HOME/$CLI_MASTER_FILE
    fi

    format info "Finding all parent functions within ${file}"

    # Finds all functions prepended with _ whether or not they are prepended with function or not
    local result=$(grep "^[function ]*[A-Za-z0-9]*[(][)]" ${file} 2>&1)
    # echo ${result}
 
    # If there is at least one result with at least one child
    if [[ -n ${result} ]]; then

       
        local replace="function"
        local replacement=""
        i=0
        while read line; do
            # This is the function
            local found_function=${line}
            local found_function=${found_function:gs/function /""}  # ZSH
            # Only use the name before the parentheses 
            # WARNING: Can't seem to strip the color out of the name which makes it unfindable, unless I remove color-always from hte grep...
            local parent_function_name=$(echo $found_function | cut -f1 -d\()

            # Verify it has at least one child
            local child_count=$(grep --color=always -c "^[function ]*[_]*${parent_function_name}_[A-Za-z0-9]*[_]*[A-Za-z]*[(][)]" ${file} 2>&1)

            # If it has at least one child then it's a parent
            # TODO Should at the red color back into this
            if [[ ${child_count} != 0 ]]; then
                echo $(echo $found_function | cut -f1 -d' ' )
            fi    

            ((i=i+1))
        done <<< "$result"

        # Cleanup and/or Garbage collection
        unset line
    fi
}

##############################################################################################
####  Helper Child Functions (For System Shell Scripts)
##############################################################################################
# These should be included as helpers with MOST System shell scrits

function _finder_help() {
    # Simple Help function

    echo ""
    format info "Finder help"
    format casual "This Spry CLI System tool is intended to find all the instances of function within a \"Family\" and display their names and the first comment in the function as a summary description"
    finder children "finder" $FINDER_SOURCE
    echo ""
    finder_examples
    format debug1 "Previous Usage" "hist functions \"finder\" "
    echo ""
}

function _finder_examples() {
    # List of usage examples
    format debug1 "Finder Help" "finder help"
    format debug1 "Finder find in default location" "finder functions \"mem\""
    format debug1 "Finder find in file " "finder functions \"mem\" \"$HOME/.bashrc\" "
}

##############################################################################################
 ########  Finder functions - END                                                      ########
  ##############################################################################################