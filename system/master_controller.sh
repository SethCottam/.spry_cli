  ###############################################################################################
 ########  Core System Functions - START                                                ########
###############################################################################################
#
# Core System Functions
# Description - These must be run in order for the terminal to be operational as intended
# Author - Seth Cottam
# Version - 5.0.1
# Status - Operational

# TODO: This is ZSH specific, need one for bash
# For the open command
MASTER_CONTROLLER_FILEPATH=${0:a}

# ${0:a:h} is the current directory :0:-7 removed the last 7 characters (/system), a bit hacky
SPRY_CLI_ROOT_DIRECTORY=${${0:a:h}:0:-7}

CONSOLE_WIDTH=$(tput cols)
CONSOLE_HEIGHT=$(tput lines)
# SPRY_WIDTH=""
# SPRY_HEIGHT=""

function set_spry_size_constraints() { 
    # Set the spry size contraints for more/better output options

    # xs, sm, md, lrg. We might add an xlg, lg if necessary
    if [[ ${CONSOLE_WIDTH} -gt 180 ]]; then # 180+
        SPRY_WIDTH="lg"  # Large
    elif [[ ${CONSOLE_WIDTH} -gt 115 ]]; then  # 115-180
        SPRY_WIDTH="md"  # Medium
    elif [[ ${CONSOLE_WIDTH} -gt 70 ]]; then  # 70-114
        SPRY_WIDTH="sm"  # Small, exactly the size of the current Spry Logo
    elif [[ ${CONSOLE_WIDTH} -eq 70 ]] || [[ ${CONSOLE_WIDTH} -lt 70 ]] ; then  # 1-69
        SPRY_WIDTH="xs"  # Extra Small
    else
        format warning "Unable to determine SPRY_WIDTH defaulting to medium settings (\"md\")"
    fi
}

function master_contoller_start() {
    # Load scripts (with error catching) that make my life easier. Viva la Bash!
    # NOTE: Cannot have relative paths!

    # Load the output scripts for handling all cli output messages
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/output/colors.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/output/format.sh silent
    # Load User Settings at the beginning and end of the Master Controller (to allow for overrides)
    load_source ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/settings.sh silent

    # Allow more outputs if it's in Development mode
    if [[ $SPRY_MODE == "development" ]]; then

        local load_source_mode="stats"  # can also be blank (ex load_source_mode="")


        format info "Loading" partial
        format spry partial
        format info " in DEVELOPMENT mode"
        # format debug1 "SPRY_CLI_ROOT_DIRECTORY" "$SPRY_CLI_ROOT_DIRECTORY"
        echo ""
        # Enable default (verbose) output from non-error source loads
        format info "Loading Spryts:"

        echo -en "[${CASUAL}STATUS${RESET}] ${CASUAL}Result${RESET}"
        if [[ ${load_source_mode} == "stats" ]]; then
            echo -en " ${INFO}[${RESET} ${DEBUG2}Functions${RESET} ${INFO}|${RESET} ${DEBUG2}TODOs${RESET} ${INFO}|${RESET} ${DEBUG2}Lines${RESET} ${INFO}]${RESET}"
        fi
        echo -e " ${CASUAL}Filepath${RESET}"

    elif [[ $SPRY_VERBOSE == true ]]; then
        local load_source_mode="stats"  # can also be blank (ex load_source_mode="")

        format info "Loading" partial
        format spry partial
        format info " in VERBOSE mode"
        echo ""

        # Enable default (verbose) output from non-error source loads
        format info "Loading Spryts:"

    else
        # Enable silent output from non-error source loads
        local load_source_mode="silent"
    fi

    # Load every shell file in the spryts (plugins) directory
    local spryts=(${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts/*.sh)
    for shell_spryt in $spryts; do
        # Load the functions into the shell
        load_source $shell_spryt ${load_source_mode}

        # TODO: Can't seem to figure out how to declare a wildcard variable names that persist in the shell
        # Store the location for lookup tools
        # EXAMPLE: cars.sh become SPRY_CARS_PATH="/path/path/filename.sh"
        local filename=${shell_spryt:t}
        local name=${filename:gs/".sh"/""}
        local temp="SPRY_${name:u}_PATH"
        # echo "SPRY_${name:u}_PATH"

        # declare -a $temp
        # declare -a ${temp}=${shell_spryt}
        # SPRY_${name:u}_PATH=${shell_spryt}
    done

    # Load every python file in the spryts (plugins) directory
    local spryts=(${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts/*.py)
    for py_spryt in $spryts; do
        # Load the python functions into the shell
        load_py_source $py_spryt $load_source_mode
    done

    # Load the System shell scripts, silently
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/settings.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/aliases.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/stats.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/spry.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/spryts.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/finder.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/goto.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/counter.sh silent
    load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/updater.sh silent

    # Load development specific shell scripts
    if [[ $SPRY_MODE == "development" ]]; then
        format info "\nLoading Development Tools:"

        # We only want to load the packager if it's Developer mode
        load_source ${SPRY_CLI_ROOT_DIRECTORY}/system/packager.sh $load_source_mode

        # Output verebosity based on load_source_mode
        load_source ${SPRY_CLI_ROOT_DIRECTORY}/development/aliases.sh $load_source_mode
        load_source ${SPRY_CLI_ROOT_DIRECTORY}/development/settings.sh $load_source_mode
        echo ""
    fi

    # Load the user specific stuff last (to allow for overrides)
    load_source ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/secrets.sh silent
    load_source ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/aliases.sh silent
    load_source ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/settings.sh silent
    load_source ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/initialization.sh silent

    # Load the system compatibility tools
    # TODO: Should load based on which OS it is
    # load_source ${MASTER_CONTROLLER_FILEPATH}/mac.sh

    # Cleanup and/or Garbage collection
    unset shell_spryt py_spryt
}

function load_source() {
    # For loading sources with error handling
    # EXAMPLE: load_source $HOME/shellscript.sh
    # EXAMPLE: load_source $HOME/shellscript.sh silent
    # TODO: look into autoload as faster alternative for zsh

    # Note silent load only silences a success it will still display an error if it exists

    if [[ -n ${1} ]]; then
        if [ -s ${1} ]; then

            # Captures the any parsing errors while silencing the CLI output
            local error_catch=`source ${1} 2>&1 1>/dev/null`

            # If the count (#) of error_catch is greater than or equal to 1 it has loaded an output
            if [[ ${#error_catch} -ge 1 ]]; then
                # We shouldn't be outputting directly on load so it's a loading error
                echo -e "[${ERROR}ERROR${RESET}] ${CASUAL}${1} encountered the following error(s):\n ${ERROR}${error_catch}${RESET}"
            else

                # If there isn't an output on load then it was successful
                source ${1}
                # The default is to show unless the slient argument was added
                if [[ ${2} == "stats" ]]; then
                    local lines_count=$(grep -c ^ ${1})
                    local functions_count=$(grep -o '[A-Za-z0-9_-]\+[\s]*()' ${1} | wc -l | tr -d ' ')
                    local todos_count=$(grep -o 'TODO' ${1} | wc -l | tr -d ' ')

                    echo -en "[${SUCCESS}SUCCESS${RESET}] ${CASUAL}Loaded${RESET}"
                    if [[ ${SPRY_WIDTH} == "lg" ]] || [[ ${SPRY_WIDTH} == "md" ]] ; then 
                        # TODO: This is the non-condesed, need a user_setting for this
                        echo -en " ${INFO}[${RESET} ${DEBUG2}Func${RESET}:${DEBUG1}${functions_count}${RESET} ${INFO}|${RESET} ${DEBUG2}TODOs${RESET}:${DEBUG1}${todos_count}${DEBUG1} ${INFO}|${RESET} ${DEBUG2}Lines${RESET}:${DEBUG1}${lines_count}${DEBUG1} ${INFO}]${RESET}"
                        echo -e " ${CASUAL}${1}${RESET}" 
                    elif [[ ${SPRY_WIDTH} == "sm" ]]; then
                        # TODO: This is the condesed, need a user_setting for this
                        echo -en " ${INFO}[${RESET} ${DEBUG2}Fnc${RESET}:${DEBUG1}${functions_count}${RESET} ${INFO}|${RESET} ${DEBUG2}TD${RESET}:${DEBUG1}${todos_count}${DEBUG1} ${INFO}|${RESET} ${DEBUG2}Ln${RESET}:${DEBUG1}${lines_count}${DEBUG1} ${INFO}]${RESET}"
                        # Abbreviated
                        echo ${1//${SPRY_CLI_ROOT_DIRECTORY}/ ...}
                        # With Logo
                        # echo ${1//${SPRY_CLI_ROOT_DIRECTORY}/ $(format spry partial)}
                    elif [[ ${SPRY_WIDTH} == "xs" ]]; then 
                        echo ${1//${SPRY_CLI_ROOT_DIRECTORY}/ ...}
                    fi
                    
                elif [[ -z ${2} ]] || [[ ${2} != 'silent' ]]; then
                    echo -e "[${SUCCESS}SUCCESS${RESET}] ${CASUAL}Loaded ${1}${RESET}"
                fi
            fi
        else
            echo -e "[${ERROR}ERROR${RESET}] ${CASUAL}${1} does not exist or is empty. Please check your file location, filename, end ensure the file has something to load.${RESET}"
        fi
    else
        echo -e "[${ERROR}ERROR${RESET}] ${CASUAL}Unable to run load_source() without including an arg for the source location ex. ~/.bashrc${RESET}"
    fi

    # Cleanup and/or Garbage collection
    unset 1
}

function load_py_source() {
    # For loading python scripts, with error handling, inside bash function runners
    # EXAMPLE: load_source $HOME/shellscript.py

    if [[ -n ${1} ]]; then
        if [ -s ${1} ]; then

            # Get the name of the file to use as the function name for calling the file
            # Eample: "code_example.py" can then be called using "code_example"
            local function_name=(${1##/*/})  # Get the last word after the last slash (filename)
            local function_name=(${function_name//.py})  # Remove the .py extention

            # Since this is just creating a function to call a file it won't error here
            # NOTE: Must have the backslashes before the @ so it saves the command rather than the output at this current moment.
            eval "${function_name}() {python ${1} \$@;}"

            # If there isn't an output on load then it was successful
            # source ${1}
            # The default is to show unless the slient argument was added
            if [[ ${2} == "stats" ]]; then
                local lines_count=$(grep -c ^ ${1})
                local functions_count=$(grep -o '[A-Za-z0-9_-]\+[\s]*()' ${1} | wc -l | tr -d ' ')
                local todos_count=$(grep -o 'TODO' ${1} | wc -l | tr -d ' ')

                echo -en "[${SUCCESS}SUCCESS${RESET}] ${CASUAL}Loaded${RESET}"
                if [[ ${SPRY_WIDTH} == "lg" ]] || [[ ${SPRY_WIDTH} == "md" ]] ; then 
                    # TODO: This is the non-condesed, need a user_setting for this
                    echo -en " ${INFO}[${RESET} ${DEBUG2}Func${RESET}:${DEBUG1}${functions_count}${RESET} ${INFO}|${RESET} ${DEBUG2}TODOs${RESET}:${DEBUG1}${todos_count}${DEBUG1} ${INFO}|${RESET} ${DEBUG2}Lines${RESET}:${DEBUG1}${lines_count}${DEBUG1} ${INFO}]${RESET}"
                    echo -e " ${CASUAL}${1}${RESET}"
                elif [[ ${SPRY_WIDTH} == "sm" ]]; then
                    # TODO: This is the condesed, need a user_setting for this
                    echo -en " ${INFO}[${RESET} ${DEBUG2}Fnc${RESET}:${DEBUG1}${functions_count}${RESET} ${INFO}|${RESET} ${DEBUG2}TD${RESET}:${DEBUG1}${todos_count}${DEBUG1} ${INFO}|${RESET} ${DEBUG2}Ln${RESET}:${DEBUG1}${lines_count}${DEBUG1} ${INFO}]${RESET}"
                    # Abbreviated
                    echo ${1//${SPRY_CLI_ROOT_DIRECTORY}/ ...}
                    # With Logo
                    # echo ${1//${SPRY_CLI_ROOT_DIRECTORY}/ $(format spry partial)}
                elif [[ ${SPRY_WIDTH} == "xs" ]]; then 
                    echo ${1//${SPRY_CLI_ROOT_DIRECTORY}/ ...}
                fi
                
            elif [[ -z ${2} ]] || [[ ${2} != 'silent' ]]; then
                echo -e "[${SUCCESS}SUCCESS${RESET}] ${CASUAL}Loaded ${1}${RESET}"
            fi
        else
            echo -e "[${ERROR}ERROR${RESET}] ${CASUAL}${1} does not exist or is empty. Please check your file location, filename, end ensure the file has something to load.${RESET}"
        fi
    else
        echo -e "[${ERROR}ERROR${RESET}] ${CASUAL}Unable to run load_py_source() without including an arg for the file location ex. ~/python_example.py${RESET}"
    fi

    # Cleanup and/or Garbage collection
    unset 1
}


##############################################################################################
####  Built-in Script Triggers
##############################################################################################

set_spry_size_constraints

master_contoller_start

###############################################################################################
 ########  Core System functions - END                                                  ########
  ###############################################################################################