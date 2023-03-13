  ###############################################################################################
 ########  Format Functions - START                                                     ########
###############################################################################################
#
# Output Fromat and Coloration Functions
# Shortcut: @output, @format
# Description - Control the visualization of the output in a simple format
# Author - Seth Cottam
# Version - 2.0.1
# Status - Stable enought to individualize

# TODO: Add examples

function format() {
    # ~$ format info "This is an example"
    # ~$ format success "Well aren't you clever"
    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi
    # echo ${1}
    # TODO: Categorize them into simple function categories that operate the same way so I don't need to build as many options
    # single=("info")
    # status=("success", "warning", "error")
    # equals=("debug1", "debug1")
    # table=[]  # this will actually format single values as a fmt function ${fmt e val} = ${e}val${x} = ${ERROR}val${RESET}

    # As a sub-family used to assist other families it does not support setting a $family which would overwrite the primary family

    # TODO: Need a bash speicific option
    # This is specific to ZSH
    zparseopts -D -E -A DashArgs -- a b

    # if (( ${+DashArgs[-a]} )); then
    #         echo "Apple";
    # fi

    # if (( ${+DashArgs[--after]} )); then
    #         echo " -- Apple";
    # fi

    # if (( ${+DashArgs[-b]} )); then
    #         echo "Banana";
    # fi

    # if (( ${+DashArgs[--before]} )); then
    #         echo "orange";
    # fi

    # if (( ${+DashArgs[--grape]} )); then
    #         echo "grape";
    # fi

    # zparseopts d=debug -debug=debug \
    #            h=help -help=help \
    #        v=vers -version=vers \
    #        \?=usage

    # [[ -n $debug ]] && setopt xtrace
    # [[ -n $help ]] && { print_help; exit }
    # [[ -n $version ]] && { print_version; exit }

    # while getopts ":a:p:" opt; do
    #   case $opt in
    #     a) arg_1="$OPTARG";;
    #     p) p_out="$OPTARG";;
    #     \?) echo "Invalid option -$OPTARG" >&2;;
    #   esac
    # done

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
        local full_fuction="_format_${1}"
        if [[ "$(whence ${full_fuction})" = "${full_fuction}" ]]; then
            if (( ${+DashArgs[-b]} )); then
                _format_newlines
            fi
            $full_fuction ${@:2}
            if (( ${+DashArgs[-a]} )); then
                _format_newlines
            fi
        else
            echo -e "${ERROR}ERROR:${RESET} ${CASUAL}format does not support \"${1}\" as an argument${RESET}"
            _format_help
        fi
    else
        _format_help
    fi
}

##############################################################################################
####  Helper Child Functions (Standard)
##############################################################################################
# These should be included as helper functions with MOST independent shell scripts

# For self identifying it's location
FORMAT_SOURCE=${0:a}

function _format_open() {
    # Open the current file with the command for opening the IDE of choice
    if [[ -n ${1} ]]; then
        local ide=${1}
    elif [[ -n ${IDE} ]]; then
        local ide=${IDE}  #  set as an Environment Variable
    else
        local ide="vim"
    fi

    format info "Opening ${FORMAT_SOURCE} with ${ide}"
    ${ide} $FORMAT_SOURCE
}

function _format_help() {
    # Formated Help using Finder function

    local temp_source=${${family}:u}_SOURCE

    echo ""
    format info "${(C)family} help"
    format casual "This helps with formatting text outputs for better readability and contrast"
    echo -e "${(U)family}_SOURCE = ${(P)temp_source}"
    finder children $family ${(P)temp_source}
    echo ""
    _${family}_examples
    echo ""
}

function _format_examples() {
    # List of usage examples
    format debug1 "Format Help" "format help"
    format debug1 "Format Open" "format open OR format open vim"
    format debug1 "Format Code without Execution" "format code \"echo \$1\""
    format debug1 "Format Codeblock without Execution" "format code \"echo \$1\""
    format debug1 "Format Catch function output in color" "format catch [success/warning/error] \"echo \$1\""
    echo ""
    format info "format info \"Example sentence\""
    format casual "format casual \"Example sentence\""
    format unique "format unique \"Example sentence\""
    format success "format success \"Example sentence\""
    format warning "format warning \"Example sentence\""
    format error "format error \"Example sentence\""
    format command "format command \"command\""
    format debug1 "Example Title" "format debug1 \"Example Title\" \"Example sentence\""
    format debug2 "Example Title" "format debug2 \"Example Title\" \"Example sentence\""
    echo ""
    format casual "Any of these can have the argument \"partial\" at the end to prevent it from creating a new line. This is particularily helpful for stringing together multiple formats into one paragraph."
}

##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having

# Additional Formatting styles
# echo -e "\e[1mbold\e[0m"
# echo -e "\e[3mitalic\e[0m"
# echo -e "\e[4munderline\e[0m"
# echo -e "\e[9mstrikethrough\e[0m"

# Better color/style handling
# ansi()          { echo -e "\e[${1}m${*:2}\e[0m"; }
# bold()          { ansi 1 "$@"; }
# italic()        { ansi 3 "$@"; }
# underline()     { ansi 4 "$@"; }
# strikethrough() { ansi 9 "$@"; }
# red()           { ansi 31 "$@"; }

function _format_special_formatting() {
    # WIP - For things like Bold, Italics, Unerline, Strikethrough, etc.

    echo -e "\e[1mbold\e[0m"
    echo -e "\e[3mitalic\e[0m"
    echo -e "\e[3m\e[1mbold italic\e[0m"
    echo -e "\e[4munderline\e[0m"
    echo -e "\e[9mstrikethrough\e[0m"
    echo -e "\e[31mHello World\e[0m"
    echo -e "\x1B[31mHello World\e[0m"

}

function _format_list() {
    # WIP For handling a set of data to include even spacing between titles and details
    # Will need an array of dicts
    # Count the characters in the title to determine what has the most characters
    format error "You never built this out"
}

function _format_single() {
    # TODO: Types are Not in use
    # format_single info this and the other
    # TODO: Cannot get this to work as expected
    upper $1
    upper $2
    # echo '1'
    type="${$(upper $1 2>&1)}"
    echo -e "${type}${2}${RESET}"
}

function _format_fill() {
    # Uses a string and a number that represents the desired total string length. It then calculates and adds the nubmber of spaces required to meet the desired string length.
    # Example: format fill "Water buffalo chips" 25
    #   Output: `Water buffalo chips      `
    if [[ -n ${1} ]] && [[ ${2} =~ "^[0-9]+$" ]]; then

        # TODO: Only works in positive numbers should add something to reduce to string plus elipses (asdfasdf...)
        local fill_length=$(( ${2} - ${#1} ))
        echo -en $1
        _format_spaces $fill_length
    else
        echo -e "${ERROR}ERROR:${RESET} ${CASUAL}Requires a string and a number that represents the desired total string length. It then calculates and adds the nubmber of spaces required to meet the desired string length.${RESET}"
    fi
}

function _format_fill_count() {
    # For adding additional spaces to a spring
    # exmaple format fill pre/post

    # TODO: need a few different options. This takes an int 4 (spaces) and a string.
    #   - Need one that gives two strings and extends the length of the second string based on the first
    #   - This should probably be

    if [[ -n ${1} ]]; then
        echo -e "${ERROR}ERROR:${RESET} ${CASUAL}Unbuilt!!!${RESET}"
    else
        echo -e "${ERROR}ERROR:${RESET} ${CASUAL}format does not support \"${1}\" as an argument${RESET}"
    fi
}

function _format_fill_match() {
    echo -e "${ERROR}ERROR:${RESET} ${CASUAL}Unbuilt!!!${RESET}"
}

function _format_spaces() {
    # For adding additional spaces

    # If the string is not empty then we only need one space
    if [[ -z ${1} ]]; then
        1=1
    fi

    # Use the built in spacing mechanism in printf
    printf "%*s" $1
}

function _format_tabs() {
    # For adding additional tabs

    # TODO: Ned to find out if there is a way to change the default width of a tab

    # If the string is empty then we only need one tab
    if [[ -z ${1} ]]; then
        local output="\t"
    else
        local output=""

        for (( i=0; i<${1}; ++i)); do
            output+="\t"
        done
    fi

    # Output with allowing backslashes and no newline
    echo -en $output
}

function _format_newlines() {
    # For adding additional new lines

    # If the string is empty then we only need one new line
    if [[ -z ${1} ]]; then
        local output="\n"
    else
        local output=""

        for (( i=0; i<${1}; ++i)); do
            output+="\n"
        done
    fi

    # Output with allowing backslashes and no newline
    echo -en $output
}

function _format_status() {
    # TODO: Types are Not in use
    # ${1^^} Should put the value called in caps
    echo -e "${${1^^}}${1^^}:${RESET} ${CASUAL}${2}${RESET}"
}

function _format_equals() {
    # TODO: Types are Not in use
    # ${1^^} Should put the value called in caps
    echo -e "${${1^^}}${2^^}${RESET} = ${CASUAL}${3}${RESET}"
}

function _format_info() {
    # Colors a single sentance
    if [[ -n ${2} ]] && [[ ${2} == "partial" ]]; then
        echo -en "${INFO}${1}${RESET} "
    else 
        echo -e "${INFO}${1}${RESET}"
    fi
}

function _format_casual() {
    # Colors a single sentance
    if [[ -n ${2} ]] && [[ ${2} == "partial" ]]; then
        echo -en "${CASUAL}${1}${RESET} "
    else 
        echo -e "${CASUAL}${1}${RESET}"
    fi
}

function _format_unique() {
    # Colors a single sentance
    if [[ -n ${2} ]] && [[ ${2} == "partial" ]]; then
        echo -en "${UNIQUE}${1}${RESET} "
    else 
        echo -e "${UNIQUE}${1}${RESET}"
    fi
}

function _format_success() {
    # Formats and colors SUCCCES and colors a single sentance.
    if [[ -n ${2} ]] && [[ ${2} == "partial" ]]; then
        echo -en "[${SUCCESS}SUCCESS${RESET}] ${CASUAL}${1}${RESET} "
    else 
        echo -e "[${SUCCESS}SUCCESS${RESET}] ${CASUAL}${1}${RESET}"
    fi
}

function _format_warning() {
    # Formats and colors WARNING and colors a single sentance.
    if [[ -n ${2} ]] && [[ ${2} == "partial" ]]; then
        echo -en "[${WARNING}WARNING${RESET}] ${CASUAL}${1}${RESET} "
    else 
        echo -e "[${WARNING}WARNING${RESET}] ${CASUAL}${1}${RESET}"
    fi
}

function _format_error() {
    # Formats and colors ERROR and colors a single sentance.
    if [[ -n ${2} ]] && [[ ${2} == "partial" ]]; then
        echo -en "[${ERROR}ERROR${RESET}] ${CASUAL}${1}${RESET} "
    else 
        echo -e "[${ERROR}ERROR${RESET}] ${CASUAL}${1}${RESET}"
    fi
}

function _format_prompt() {
    # Formats and colors USER INPUT, a different color for default text, another color for sentance 1, and another for show how to finish
    # TODO: I don't know that I love this coloration
    if [[ -n ${2} ]] && [[ ${2} == "partial" ]]; then
        echo -en "${DEBUG1}USER INPUT${RESET}: ${CASUAL}Please type ${DEBUG1}${1}${RESET} ${CASUAL}and press${RESET} ${WARNING}[ENTER]${RESET} "
    else 
        echo -e "${DEBUG1}USER INPUT${RESET}: ${CASUAL}Please type ${DEBUG1}${1}${RESET} ${CASUAL}and press${RESET} ${WARNING}[ENTER]${RESET}"
    fi
}

function _format_debug1() {
    # Colors sentance one and with a different color for sentance two.
    if [[ -n ${3} ]] && [[ ${3} == "partial" ]]; then
        echo -en "${DEBUG1}${1}${RESET} = ${CASUAL}${2}${RESET} "
    else 
        echo -e "${DEBUG1}${1}${RESET} = ${CASUAL}${2}${RESET}"
    fi
}

function _format_debug2() {
    # Colors sentance one and with a different color for sentance two.
    if [[ -n ${3} ]] && [[ ${3} == "partial" ]]; then
        echo -en "${DEBUG2}${1}${RESET} = ${CASUAL}${2}${RESET} "
    else 
        echo -e "${DEBUG2}${1}${RESET} = ${CASUAL}${2}${RESET}"
    fi
}

function _format_command() {
    # Special formatting for the express purpose of showing a cli command

    # EXAMPLE: format command "mkdir new_directory"
    # TODO should allow passing -n option for no space at the end
    # echo -e "${CASUAL}(${RESET} ${DEBUG2}~\$${RESET} ${SPECIAL}${1}${RESET} ${CASUAL})${RESET}"
    if [[ -n ${2} ]] && [[ ${2} == "partial" ]]; then
        echo -en "${DEBUG2}~\$${RESET} ${UNIQUE}${1}${RESET}"
    else 
        echo -e "${DEBUG2}~\$${RESET} ${UNIQUE}${1}${RESET}"
    fi

    # TODO: if zsh should show ${DEBUG1}~${RESET}${WARNING}✗${RESET}
}

function _format_code() {
    # For displaying a code without executing it
    if [[ -n ${3} ]] && [[ ${3} == "partial" ]]; then
        echo -en "${DEBUG1}${1}${RESET} = ${CASUAL}"
        printf "%s" "${2}"
        echo -en "${RESET} "
    else 
        echo -en "${DEBUG1}${1}${RESET} = ${CASUAL}"
        printf "%s" "${2}"
        echo -e "${RESET}"
    fi
}

function _format_codeblock() {
    # For displaying a code block without executing it

    # Emaple:
    # format codeblock "example code" "
    # Stuff goes here
    # and here
    # "
    if [[ -n ${3} ]] && [[ ${3} == "partial" ]]; then
        echo -e "${DEBUG1}${1}${RESET}: ${CASUAL}"
        printf "%s" "${2}"
        echo -en "${RESET}"
    else 
        echo -e "${DEBUG1}${1}${RESET}: ${CASUAL}"
        printf "%s" "${2}"
        echo -e "${RESET}"
    fi
}

function _format_catch() {
    # Wrapping outputs of commands with single color formatting
    # Example: format catch error "kubectl config use-context aws_qa_cjis_aue1_platform"
    # example: format catch error "kubectl config use-context aws_qa_cjis_aue1_platform" partial

    # The first argument is the color so it needs to be captialized
    1=${${1}:u}

    if [[ -n ${3} ]] && [[ ${3} == "partial" ]]; then
        echo -en ${(P)1}; eval $2; echo -en ${RESET}
    else 
        echo -e ${(P)1}; eval $2; echo -en ${RESET}
    fi
}

function _format_spry() {
    # Spry Logo that gets it's own special formats

    # TODO: Should probably add args to control bold, underline, etc.

    # Must not create a newline, since it's anticipated to be inline
    # TODO: Need to use a better word tha EXPLAINATION, or EXPOUND
    # EXPLAINATION:
    #   \033[ = Precursor | 1 = Bold | ; = and | 4 = underline | 36m = color
    echo -n "\033[1;4;36mSpry\033[1;4;35mCLI${RESET}"

}


# TODO: The entire following section is a way to format and unformat.

function _format_simplify() {
    # WIP - Intended to reverse format a format command into a non-dependent line of code
    # ~$ format info "This is an example"
    # ~$ format success "Well aren't you clever"
    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi
    # TODO: Categorize them into simple function categories that operate the same way so I don't need to build as many options
    # single=("info")
    # status=("success", "warning", "error")
    # equals=("debug1", "debug1")
    # table=[]  # this will actually format single values as a fmt function ${fmt e val} = ${e}val${x} = ${ERROR}val${RESET}

    # If the string is not empty
    if [[ -n ${1} ]]; then
        full_fuction="format_simplify_$1"
        if [[ "$(whence ${full_fuction})" = "${full_fuction}" ]]; then
            $full_fuction $@
        else
            echo -e "${ERROR}ERROR:${RESET} ${CASUAL}\"${family} simplify\" does not support \"${1}\" as an argument${RESET}"
            _format_simplify_help
        fi
    else
        _format_simplify_help
    fi
}

function _format_simplify_help() {
    # Formated Help using Finder function

    local temp_source=${${family}:u}_SOURCE

    echo ""
    format info "${(C)family} help"
    format casual "This function family in an example for other function families"
    echo -e "${(U)family}_SOURCE = ${(P)temp_source}"
    finder children ${family}_simplify ${(P)temp_source}
    echo ""
    # _${family}_examples
    # echo ""
}

function _format_simplify_info() {
    # WIP - This is a reversal to change a formated string into a standard string
    # TODO: Not sure I like simplify. Maybe decode, decipher, decrypt, translate,
    # This takes a standard format string like format simplify info "This is an info"
    #   - Turns it into echo -e "${INFO}This is an info${RESET}"
    #   - TODO: Need to add similar functions to colors.sh
    printf "echo -e \"${INFO}${2}${RESET}\""
}

###############################################################################################
 ########  Format Functions - End                                                       ########
  ###############################################################################################