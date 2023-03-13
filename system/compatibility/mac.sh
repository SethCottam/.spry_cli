  ##############################################################################################
 ########  Mac Compatibility Funcitons                                               ########
##############################################################################################
#
# Mac Compatibility
# Shortcut - @mac_compatibility
# Description - Compatibility tools for the Various Mac OS versions
# Author - Seth Cottam
# Dependencies - colors, format
# Version - 1.0.0
# Status - Work in Progress

# NOTE: Built in script trigger at the end of this shell script

function mac_compatability() {
    # Increases Mac compatability

    # TODO: Need to allow for 
    if [[ -n ${OS} ]] && [[ ${OS} == "Mac" ]]; then
        echo -en "${INFO}${1}${RESET} "
    else 
        echo -e "${INFO}${1}${RESET}"
    fi

    # This only needs to be set if the autodetect doesn't work for your system
    # local family="example"  # {{TEMPLATE_FAMILY_NAME}}

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
####  Child Functions
##############################################################################################

function _mac_compatability() {
    # An Example child function
    echo -e "Arguments"
    echo -e "\$0 " $0
    echo -e "\$1 " $1
    echo -e "\$2 " $2
    echo -e "\$3 " $3
    echo -e "\$4 " $4
    # format success "You ran the ${family} thing function"
}

# TODO: Finish this
function _mac_compatability_browser() {
    # WIP - An Example child function

    # TODO: needs to check against a full lowercase ${BROWSER}, need to add this in
    if [[ -n ${BROWSER} ]]; then
        if [[ ${BROWSER} == "chrome" ]]; then
            export BROWSER_APPLICATION="Google Chrome"
        elif [[ ${BROWSER} == "firefox" ]]; then
            export BROWSER_APPLICATION="Firefox"  # TODO: Verify this
        elif [[ ${BROWSER} == "brave" ]]; then
            export BROWSER_APPLICATION="Brave Browser"
        elif [[ ${BROWSER} == "safari" ]]; then
            export BROWSER_APPLICATION="Safari"  # TODO: Verify this
        else
            format error "Can't find Mac browser application name for the browser named ${} in your user_settings.sh"
        fi
    elif [[ -n ${funcstack[1]} ]]; then
        local family=${funcstack[1]}
    else
        format error "Can't detect the function name, please set family=${family} manually"
    fi
}

function _mac_compatability_application_open() {
    # WIP - formats a message for opening and/or showing how to open a from command line
    echo -e "open -a 'Google Chrome' 'https://ensdev.servicenowservices.com/nob_sdsp'"
}

##############################################################################################
####  Built-in Script Trigger
##############################################################################################

mac_compatability

##############################################################################################
 ########  Example Family function - END  # {{TEMPLATE_FAMILY}}                        ########
  ##############################################################################################