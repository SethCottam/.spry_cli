#!/bin/zsh

  ##############################################################################################
 ########  Spry CLI Install                                                            ########
##############################################################################################
#
# Description - OPTIONAL Global Variables for Signal Connectors. These will overwrite dfaults.
#   These are user specific to allow for better flexibility in usage.
# Note - This is currently optimized for ZSH on MAC OSX
# Dependencies - ZSH (or possibly Bash), 1password-cli (op), Brew and Cask (Only if 1pass
#   wans't previously installed)
# Status - Work in Progess

# TODO: consider requesting name and email for
#   - git config --local user.name ''
#   - git config --local user.email ''

# Constants
local AUTOLOADER="${0:a:h}/autoloader.sh"  # We're including the developer default for now
local AUTOLOADER_ARG="verbose"  # If you need to manually change this after an install run: vim $HOME/.zshrc
local SHELL_FILE=$HOME/.zshrc  # TODO: This should be made more flexible

# Temporary variables
local custom_files_directory="../spry_cli_custom"

# source /Users/username/spry_cli/autoloader.sh development


##############################################################################################
####  Format Functions
##############################################################################################
# Because we all love pretty outputs

# Standard colors
local SUCCESS='\033[0;32m'    # Green
local WARNING='\033[0;33m'    # Yellow
local ERROR='\033[0;31m'      # Red
local INFO='\033[01;34m'      # Blue
local UNIQUE='\033[00;35m'    # Light Purple
local CASUAL='\033[02;37m'    # Grey
local DEBUG1='\033[00;36m'    # Light Blue
local DEBUG2='\033[02;36m'    # Teal
local RESET='\033[0m'         # Back to Default

info() {
    # Colors a single sentance in Blue
    echo -e "${INFO}${1}${RESET}"
}

success() {
    # Formats and colors [SUCCCES] and colors a single sentance.
    echo -e "[${SUCCESS}SUCCESS${RESET}] ${CASUAL}${1}${RESET}"

}

warning() {
    # Formats and colors [WARNING] and colors a single sentance.
    echo -e "[${WARNING}WARNING${RESET}] ${CASUAL}${1}${RESET}"
}

error() {
    # Formats and colors [ERROR] and colors a single sentance.
    echo -e "[${ERROR}ERROR${RESET}]   ${CASUAL}${1}${RESET}"  # Extra spacing is intentional
}

prompt() {
    # Formats and colors asking the user for information
    echo -e "${DEBUG1}USER INPUT${RESET}: ${CASUAL}Please type your ${DEBUG1}${1}${RESET} ${CASUAL}and press${RESET} ${WARNING}[ENTER]${RESET}"
}


##############################################################################################
####  Installation Functions
##############################################################################################
# The core of what this shell script is trying to accomplish

# TODO: This output SUCKS where's my super sweet MOTD?!?
# Example Output:

# Welcome to the installation of your new Best Friend, the Spry CLI!
#
#
# AUTOLOADER /Users/username/spry_cli/autoloader.sh
# Determining which shell you're using
# [SUCCESS] ZSH is a compatible shell
# Attempting to find autoloaded core shell files to ensure the new files will load automatically
# [SUCCESS] Located /Users/username/.zshrc
# [SUCCESS] Autoloading of "/Users/username/spry_cli/autoloader.sh" enabled
# [SUCCESS] INSTALLATION COMPLETE!
#

installation() {
    # Walks through the installation dependancies and installation
    info "\nWelcome to the installation of your new Best Friend, the Spry CLI!\n"

    echo $INSTALLER_ROOTPATH
    # TODO: Move this over to the Bash Catalog
    # echo "a ${0:a}"  # Current path + the function
    # echo "A ${0:A}"  # Current path + the function
    # echo "h ${0:h}"  # current location "."" (so it's worthless)
    # echo "a:h ${0:a:h}"  # The run root path

    # Create and fill the custom user directory
    create_user_directory
    copy_installation_files

    # Validates we can install on this shell
    check_shell
    # Ensures they're loaded into your shell on start
    source_files

    success "INSTALLATION COMPLETE!\n"
}

create_user_directory() {
    info "Creating a directory for your custom Spry CLI files"

    local result=$(mkdir ${custom_files_directory} 2>&1)
    if [[ -z ${result} ]]; then
        error ${result}
        installation_failure
    else
        success "Created ${custom_files_directory} for your custom Spry CLI files and settings"
    fi 
}

copy_installation_files() {
    info "Copying settings files and example files to ${custom_files_directory}"
    local result=$(cp -av installation_files/ ${custom_files_directory} 2>&1)
    # TODO: User Initialaztion needs cleanup
    #   - it also includes stats which is a spryt not a default, may want to move it to a core function... not sure yet. If so it should be moved out of the readme.

    if [[ ${result} =~ "cp"  ]]; then
        error "There was an issue copying from spry_cli/installation_files to ${custom_files_directory}"
        error ${result}
        installation_failure
    else
       success "Files copied"
    fi
}

check_shell() {
    info "Determining which shell you're using"
    local result=$(echo $SHELL 2>&1)
    # TODO: My managed device seems to run as under /bin/sh even though command line with and without sudo runs as /bin/zsh.
    #   sudo (on the managed box) reems to redirect to /bin/sh... interesting
    
    if [[ ${result} =~ "/bin/zsh"  ]]; then
        success "ZSH is a compatible shell"
    elif [[ ${result} =~ "/bin/bash" ]]; then
        warning "Bash is not currently a fully compatible shell... yet. Until then beware that some functionality may be incomplete or non-functional."
    else
        error "Our script is unfamiliar with the shell \"${result}\""
        installation_failure
    fi
}

check_shell_autoload_files() {
    # Check if the core shell files exist or create one
    info "Attempting to find autoloaded core shell files to ensure the new files will load automatically"

    # TODO: Should expand this into BASH (.zshrc) and Older OSX (.bash_profile)
    if [[ ! -f "$SHELL_FILE" ]]; then
        local result=$(touch "$SHELL_FILE" 2>&1)

        if [[ -z ${result} ]]; then
            success "Created SHELL_FILE"
        else
            error "Unable to find or create $SHELL_FILE"
            installation_failure
        fi
    else
        success "Located $SHELL_FILE"
    fi
}

source_files() {
    # Source spry_cli in the default shell

    check_shell_autoload_files

    local result=$(grep $AUTOLOADER $SHELL_FILE 2>&1)

    # TODO: should loop this
    if [[ -z ${result} ]]; then
        # TODO: Should have some actual checks for this
        echo "" >> $SHELL_FILE
        echo "# Spry CLI - The worlds best all purpose CLI tool!" >> $SHELL_FILE
        echo "export SPRY_CLI_CUSTOM_ROOT_DIRECTORY=\"/$HOME/spry_cli_custom\"" >> $SHELL_FILE
        echo "source $AUTOLOADER $AUTOLOADER_ARG" >> $SHELL_FILE
        success "Autoloading of \"$AUTOLOADER\" enabled"
    else
        warning "Autoloading is already enabled for \"$AUTOLOADER\""
    fi
}

installation_failure() {
    error "Unable to complete the installation"
    exit 1
}


##############################################################################################
####  Execution
##############################################################################################
# SEND IT!!!!

installation

##############################################################################################
 ########  User Signal Connectors Variables                                            ########
  ##############################################################################################
