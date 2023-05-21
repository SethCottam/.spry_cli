  ##############################################################################################
 ########  Colors functions - START                                                    ########
##############################################################################################
#
# Colors
# Shortcut - @colors
# Description - Colors constants and functions
# Author - Seth Cottam
# Dependencies - finder
# Anti-dependencies - format (should not be used for any core functions)
# Status - Operational
# Notes: This should be the first thing sourced so it's very intentionally non-dependant on other things to run any default commnads

# TODO: Look into incorperating some of https://misc.flogisoft.com/bash/tip_colors_and_formatting
# TODO: running `colors all` has multiple problems. Need to fix it up`

# For self identifying it's location
COLORS_SOURCE=${0:a}

# Standard colors
SUCCESS='\033[0;32m' 	# Green
WARNING='\033[0;33m' 	# Yellow
ERROR='\033[0;31m' 		# Red
INFO='\033[01;34m' 		# Blue
UNIQUE='\033[00;35m'	# Magento
CASUAL='\033[02;37m'	# Grey
DEBUG1='\033[00;36m'	# Light Blue
DEBUG2='\033[02;36m'	# Teal
RESET='\033[0m' 		# Back to Default

# Highly concise colors
R="\033[0;31m"  # Red
G="\033[0;32m"  # Green
Y="\033[0;33m"  # Yellow
B="\033[01;34m" # Blue
M="\033[0;35m"  # Magento
C="\033[0;36m"  # Cyan
W="\033[0;37m"  # White
D="\033[02;37m" # Dim (Grey, but G was already taken)
T="\033[02;36m" # Teal
X="\033[0m"     # Reset the color


colors() {
    # The Example parent function
	# ~$ example test1 test2 test3 test4
    if [ -d "$1" ]; then
        # cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi

    # This only needs to be set if the autodetect doesn't work for your system
    # family="example"

    # Autodetect family
    if [[ -n ${FUNCNAME[0]} ]]; then
        family=$(FUNCNAME[0])
    elif [[ -n ${funcstack[1]} ]]; then
        family=${funcstack[1]}
    else
        echo -e "${ERROR}ERROR:${RESET} ${CASUAL}Can't detect the function name, please set family= manually ${RESET}"
    fi

	# If the string is not empty
	if [[ -n ${1} ]]; then
		full_function="${family}_${1}"
		if [[ "$(whence ${full_function})" = "${full_function}" ]]; then
			echo -e "${SUCCESS}SUCCESS:${RESET} ${CASUAL}Running ${0} ${1}${RESET}"
			# Call the family_arg1 then pass all args >= arg position 2
            ${family}_${1} ${@:2}
		else
			echo -e "${ERROR}ERROR:${RESET} ${CASUAL}${family} does not support \"${1}\" as an argument${RESET}"
			${family}_help
		fi
	else
		 ${family}_help
	fi

    # Cleanup and/or Garbage collection
    unset family
}

##############################################################################################
####  Helper Child Functions (Standard)
##############################################################################################
# These should be included as helpers with MOST parent functions

colors_help() {
    # Formated Help using Finder function
    echo ""
    format info "${(C)family} help"
    format casual "Poviding color and readability to a world of black and white"
    # Finder functions $family $EXAMPLE_SOURCE
    finder functions $family $COLORS_SOURCE

    echo ""
    ${family}_examples
    format debug1 "Previous Usage" "hist functions ${family}"
    echo ""
}

colors_examples() {
    # List of usage examples
    echo -e "${DEBUG1}${(C)family} help${RESET}  = ${CASUAL}${family} help${RESET}"
    echo -e "${DEBUG1}Show All Colors${RESET} = ${CASUAL}${family} all${RESET}"
    echo -e "${DEBUG1}Show Colors Constants${RESET} = ${CASUAL}${family} termed${RESET}"
}

##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having

colors_all() {
    # Shows all the colors we've considered
	echo -e "${SUCCESS}SUCCESS:${RESET} ${CASUAL}You totally ran the ${family}_thing function${RESET}"
	echo -e '\033[00;30m 00;30m \033[00m \033[02;30m 02;30m \033[00m \033[01;30m 01;30m \033[00m \033[01;40m 01;40m \033[00m \033[00;31m 00;31m \033[00m \033[02;31m 02;31m \033[00m \033[01;31m 01;31m \033[00m \033[01;41m 01;41m \033[00m \033[00;32m 00;32m \033[00m \033[02;32m 02;32m \033[00m \033[01;32m 01;32m \033[00m \033[01;42m 01;42m \033[00m \033[00;33m 00;33m \033[00m \033[02;33m 02;33m \033[00m \033[01;33m 01;33m \033[00m \033[01;43m 01;43m \033[00m \033[00;34m 00;34m \033[00m \033[02;34m 02;34m \033[00m \033[01;34m 01;34m \033[00m \033[01;44m 01;44m \033[00m \033[00;35m 00;35m \033[00m \033[02;35m 02;35m \033[00m \033[01;35m 01;35m \033[00m \033[01;45m 01;45m \033[00m \033[00;36m 00;36m \033[00m \033[02;36m 02;36m \033[00m \033[01;36m 01;36m \033[00m \033[01;46m 01;46m \033[00m \033[00;37m 00;37m \033[00m \033[02;37m 02;37m \033[00m \033[01;37m 01;37m \033[00m \033[01;47m 01;47m \033[00m'
}

colors_termed() {
	# Shows all the colors we've made easy to use colorization terms for
	echo -e "${INFO}Terms that produce color${RESET}"
    echo -e "${CASUAL}EXAMPLE: ${DEBUG2}echo \"${RESET}${DEBUG1}\${SUCCESS}${RESET}${CASUAL}WINNER${RESET}${DEBUG1}\${RESET} \${CASUAL}${RESET}${CASUAL}You won${RESET}${DEBUG1}\${RESET}${RESET}${DEBUG2}\"${RESET}"
    echo ""
	echo -e "${SUCCESS}SUCCESS${RESET}"
	echo -e "${WARNING}WARNING${RESET}"
	echo -e "${ERROR}ERROR${RESET}"
	echo -e "${INFO}INFO${RESET}"
    echo -e "${UNIQUE}UNIQUE${RESET}"
	echo -e "${CASUAL}CASUAL${RESET}"
	echo -e "${DEBUG1}DEBUG1${RESET}"
	echo -e "${DEBUG2}DEBUG2${RESET}"
	echo -e "${RESET}RESET${RESET}"
    echo ""

    echo -e "EXAMPLE:\t\t\t\t\t\t| RESULT:"
    echo -e "${T}echo \"${X}${C}\${G}${X}${D}WINNER!${X}${C}\${X} \${D}${X}${D}You are awesome.${X}${C}\${X}${X}${T}\"${X}\t\t| ${G}WINNER!${X} ${D}You are awesome.${X}"
    echo -e "${R}R = RED${X}"
    echo -e "${G}G = GREEN${X}"
    echo -e "${Y}Y = YELLOW${X}"
    echo -e "${B}B = BLUE${X}"
    echo -e "${M}M = MAGENTO${X}"
    echo -e "${C}C = CYAN${X}"
    echo -e "${W}W = WWHITE${X}"
    echo -e "${D}D = DIM${X}"
    echo -e "${T}T = TEAL${X}"
    echo -e "${X}X = RESET${X}"
    echo ""
}

##############################################################################################
 ########  Color functions - END                                                       ########
  ##############################################################################################