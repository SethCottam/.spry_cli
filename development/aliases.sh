  ##############################################################################################
 ########  Aliases (Development) - START                                               ########
##############################################################################################
#
# Aliases
# Shortcut: @dev_aliases, @dev_alias
# Description - Shortcuts to directories, functions, single line (sometime multiple) bash, etc.
# Author - Seth Cottam
# Status - Operational
#
# NOTES: Aliases in ZSH don't require a directory location to be prepended with cd to cd to it


##############################################################################################
####  LAZY, supremely lazy Aliases - @lazy
##############################################################################################
# For when 7 characters is simply too big of a commitment
# alias open_cli="sublime $CLI_ROOT_DIRECTORY"
alias open_cli_all="open_cli_colors;"
alias open_cli_colors="sublime $CLI_ROOT_DIRECTORY/output/colors.sh"
alias open_cli_format="sublime $CLI_ROOT_DIRECTORY/output/format.sh"
alias open_cli="bashrc; bashprofile; sublime ~/.bash_aliases; mem_open; format_open; sublime ~/.oh-my-zsh/oh-my-zsh.sh;"

# TEMP ONLY
alias load="source ~/spry_cli/development/master_controller.sh"

##############################################################################################
 ########  Aliases (Development) - END                                                 ########
  ##############################################################################################