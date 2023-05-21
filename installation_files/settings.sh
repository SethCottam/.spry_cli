  ##############################################################################################
 ########  Settings (User) - START                                                     ########
##############################################################################################
#
# Settings
# Shortcut: @dev_settings
# Description - Global Settings for Spry Development
# Author - Seth Cottam
# Status - Pending


##############################################################################################
####  Custom SPRY CLI settings (still globally accessible)
##############################################################################################
# Thse will to help with SPRY CLI operations and help to override or dedirect defaults

# The name and folder location of your Spry CLI custom folder
export SPRY_CLI_CUSTOM_ROOT_DIRECTORY=${0:h}
export SPRY_CLI_COUNTER_DIRECTORY="${0:h}/file_storage/counters"

# Overwrite core SPRY CLI settings
# export SPRY_MODE="fast"
# export SPRY_VERBOSE=true

# Optional ease of use settings
# export OS="Mac"
# export BROWSER="Brave"
# export BROWSER_APP="Brave Browser"
# export IDE=subl  # The command for opening your favorite Integrated Development Environment tool

##############################################################################################
####  Custom Global Settings (For 3rd party CLI tools)
##############################################################################################
# Thse are to help with any other exports, 3rd party tools, local development, etc

# Flask Settings
# export FLASK_APP=xml_api.py
# export FLASK_APP="heroes_api.py"
# export SQLALCHEMY_TRACK_MODIFICATIONS=False

# This has to with saving history
# Example HIST_IGNORE="*secret.server.com*:ytalk*:fortune"  # Oh-My-Zsh
# export HIST_IGNORE="history:ls"  # Oh-My-Zsh
# export HISTORY_IGNORE="re:clr:history"  # ZSH
# export HISTIGNORE="re:clr:history"  # BASH

##############################################################################################
 ########  Settings (User) - END                                                       ########
  ##############################################################################################