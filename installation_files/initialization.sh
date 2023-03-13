  ###############################################################################################
 ########  User Initialization functions - START                                        ########
###############################################################################################
#
# Core Functions
# Description - These are intentended to be run each time the Spry CLI is initalized. This
#   this allows the user run a subset of functions, scripts, etc at load time.
# Author - Seth Cottam
# Status - Operational

# TODO: This is ZSH specific, need one for bash
# For the open command
USER_INITIALIZATION_FILEPATH=${0:a}

# NOTE: Use flat commands, file functions, or any function from within the Spry CLI

# TODO: This should probably be a spryts that is called from this file
# TODO: Might want to turn this into a system tool instead
##############################################################################################
####  Spry CLI Stats
##############################################################################################
#    ___                  ___ _    ___   ___ _        _
#   / __|_ __ _ _ _  _   / __| |  |_ _| / __| |_ __ _| |_ ___
#   \__ \ '_ \ '_| || | | (__| |__ | |  \__ \  _/ _` |  _(_-<
#   |___/ .__/_|  \_, |  \___|____|___| |___/\__\__,_|\__/__/
#       |_|       |__/

# Show stats
# EXAMPLE:
# S |-----------|---------|-----------|-------|----------|-------------|
# T | Functions | Aliases | Constants | TODOs | Comments | Total Lines |
# A |-----------|---------|-----------|-------|----------|-------------|
# T | 587       | 169     | 132       | 303   | 2601     | 11139       |
# S |-----------|---------|-----------|-------|----------|-------------|

# Show stats
# EXAMPLE:
# S |-----------|--------|-----------|--------|---------------|--------|
# T | Aliases   | 169    | Comments  | 2601   | Total Lines   | 11139  |
# A | Functions | 587    | TODOs     | 303    | Shell Spryts  | 14     |
# T | Families  | 17     | Tests     | 0      | Python Spryts | 2      |
# S |-----------|--------|-----------|--------|---------------|--------|

# Totals char length displat limit
local totals_char_limit=7

# Get the basic totals
local total_todos=$(stats todo ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts)
local total_functions=$(stats functions ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts)
local total_comments=$(stats comments ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts)
local total_shell_spryts=$(stats shell_spryts ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts)
local total_python_spryts=$(stats python_spryts ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts)
local total_families=$(stats families)
# local total_children="WIP"
local total_tests="WIP"

# Get the combined totals
local total_aliases=$(( $(stats aliases ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts) + $(stats aliases ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/aliases.sh) ))
local total_constants=$(( $(stats constants ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts) + $(stats constants ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/settings.sh) ))

# Get the total number of lines
local array_of_lines=("${(@f)$(stats lines ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/spryts)}")  # Get the multiline string as an array
local total_lines=${${array_of_lines[-1]}%" total"}  # Remove the " total" suffix
local total_lines=${total_lines#" "}  # Remove the space prefix


# Totals char length dipslay limit
local usage_char_limit=7

# Get the Usage totals
# local total_usage=$(counter check)
local core_usage=$(counter check_core)
local spryt_usage=$(counter check_spryt)
local alias_usage=$(counter check_alias)
local help_usage=$(counter check_help)
local total_usage=$(( ${help_usage} + ${core_usage} + ${spryt_usage} + ${alias_usage} ))

# Output the ASCII Art
# echo -e "${M}   ___                  ___ _    ___   ___ _        _      ${X}"
# echo -e "${M}  / __|_ __ _ _ _  _   / __| |  |_ _| / __| |_ __ _| |_ ___${X}"
# echo -e "${M}  \__ \ '_ \ '_| || | | (__| |__ | |  \__ \  _/ _\` |  _(_-<${X}"
# echo -e "${M}  |___/ .__/_|  \_, |  \___|____|___| |___/\__\__,_|\__/__/${X}"
# echo -e "${M}      |_|       |__/                                       ${X}"

# Output the stats table
# TODO: Need to fix the spacing format
# TODO: Add number of Spryts
# echo -e "${B}|-----------|---------|-----------|-------|----------|-------------|${X}"
# echo -e "${B}|${X} ${C}Functions${X} ${B}|${X} ${C}Aliases${X} ${B}|${X} ${C}Constants${X} ${B}|${X} ${C}TODOs${X} ${B}|${X} ${C}Comments${X} ${B}|${X} ${C}Total Lines${X} ${B}|${X}"
# echo -e "${B}|-----------|---------|-----------|-------|----------|-------------|${X}"
# echo -e "${B}|${X} ${C}$total_functions${X}$(format spaces 6) ${B}|${X} ${C}$total_aliases${X}$(format spaces 4) ${B}|${X} ${C}$total_constants${X}$(format spaces 7) ${B}|${X} ${C}$total_todo${X}$(format spaces 2) ${B}|${X} ${C}$total_comments${X}$(format spaces 4) ${B}|${X} ${C}$total_lines${X}$(format spaces 7) ${B}|${X}"
# echo -e "${B}|-----------|---------|-----------|-------|----------|-------------|${X}"


# Show stats
# EXAMPLE:
# S |-----------|---------|-----------|-------|----------|-------------|
# T | Functions | Aliases | Constants | TODOs | Comments | Total Lines |
# A |-----------|---------|-----------|-------|----------|-------------|
# T | 587       | 169     | 132       | 303   | 2601     | 11139       |
# S |-----------|---------|-----------|-------|----------|-------------|
# echo -e "${M}S${X} ${B}|-----------|---------|-----------|-------|----------|-------------|${X}"
# echo -e "${M}T${X} ${B}|${X} ${C}Functions${X} ${B}|${X} ${C}Aliases${X} ${B}|${X} ${C}Constants${X} ${B}|${X} ${C}TODOs${X} ${B}|${X} ${C}Comments${X} ${B}|${X} ${C}Total Lines${X} ${B}|${X}"
# echo -e "${M}A${X} ${B}|-----------|---------|-----------|-------|----------|-------------|${X}"
# echo -e "${M}T${X} ${B}|${X} ${C}$total_functions${X}$(format spaces 6) ${B}|${X} ${C}$total_aliases${X}$(format spaces 4) ${B}|${X} ${C}$total_constants${X}$(format spaces 6) ${B}|${X} ${C}$total_todos${X}$(format spaces 2) ${B}|${X} ${C}$total_comments${X}$(format spaces 4) ${B}|${X} ${C}$total_lines${X}$(format spaces 6) ${B}|${X}"
# echo -e "${M}S${X} ${B}|-----------|---------|-----------|-------|----------|-------------|${X}"
# echo ""

# Show stats
# EXAMPLE:
# S |-----------|--------|-----------|--------|---------------|--------|
# T | Aliases   | 169    | Comments  | 2601   | Total Lines   | 11139  |
# A | Functions | 587    | TODOs     | 303    | Shell Spryts  | 14     |
# T | Families  | 17     | Tests     | 0      | Python Spryts | 2      |
# S |-----------|--------|-----------|--------|---------------|--------|

# Show stats totals (number spacing adjusts automatically)
echo -e "${M}S${X} ${B}|-----------|---------|-----------|---------|---------------|---------|${X}"
echo -e "${M}T${X} ${B}|${X} ${C}Aliases${X}$(format spaces 2) ${B}|${X} ${C}$(format fill ${total_aliases} ${totals_char_limit})${X} ${B}|${X} ${C}Comments${X}$(format spaces 1) ${B}|${X} ${C}$(format fill ${total_comments} ${totals_char_limit})${X} ${B}|${X} ${C}Total Lines${X}$(format spaces 2) ${B}|${X} ${C}$(format fill ${total_lines} ${totals_char_limit})${X} ${B}|${X}"
echo -e "${M}A${X} ${B}|${X} ${C}Functions${X}$(format spaces 0) ${B}|${X} ${C}$(format fill ${total_functions} ${totals_char_limit})${X} ${B}|${X} ${C}TODOs${X}$(format spaces 4) ${B}|${X} ${C}$(format fill ${total_todos} ${totals_char_limit})${X} ${B}|${X} ${C}Shell Spryts${X}$(format spaces 1) ${B}|${X} ${C}$(format fill ${total_shell_spryts} ${totals_char_limit}) ${X}${B}|${X}"
echo -e "${M}T${X} ${B}|${X} ${C}Families${X}$(format spaces 1) ${B}|${X} ${C}$(format fill ${total_families} ${totals_char_limit})${X} ${B}|${X} ${C}Tests${X}$(format spaces 4) ${B}|${X} ${C}$(format fill ${total_tests} ${totals_char_limit})${X} ${B}|${X} ${C}Python Spryts${X}$(format spaces 0) ${B}|${X} ${C}$(format fill ${total_python_spryts} ${totals_char_limit})${X} ${B}|${X}"
echo -e "${M}S${X} ${B}|-----------|---------|-----------|---------|---------------|---------|${X}"
echo ""


# Show usage
# EXAMPLE:
# U |---------|---------|---------|---------|---------|
# S | Core    | Spryts  | Aliases | Help    | Total   |
# A |---------|---------|---------|---------|---------|
# G | 1700    | 1133    | 18      | 14      | 2865    |
# E |---------|---------|---------|---------|---------|

# Show usage totals (number spacing adjusts automatically)
echo -e "${M}U${X} ${B}|---------|---------|---------|---------|---------|${X}"
echo -e "${M}S${X} ${B}|${X} ${C}$(format fill "Core" ${usage_char_limit})${X} ${B}|${X} ${C}$(format fill "Spryts" ${usage_char_limit})${X} ${B}|${X} ${C}$(format fill "Aliases" ${usage_char_limit})${X} ${B}|${X} ${C}$(format fill "Help" ${usage_char_limit})${X} ${B}|${X} ${C}$(format fill "Total" ${usage_char_limit})${X} ${B}|${X}"
echo -e "${M}A${X} ${B}|---------|---------|---------|---------|---------|${X}"
echo -e "${M}G${X} ${B}|${X} ${C}$(format fill ${core_usage} ${usage_char_limit})${X} ${B}|${X} ${C}$(format fill ${spryt_usage} ${usage_char_limit})${X} ${B}|${X} ${C}$(format fill ${alias_usage} ${usage_char_limit})${X} ${B}|${X} ${C}$(format fill ${help_usage} ${usage_char_limit})${X} ${B}|${X} ${C}$(format fill ${total_usage} ${usage_char_limit})${X} ${B}|${X}"
echo -e "${M}E${X} ${B}|---------|---------|---------|---------|---------|${X}"
echo ""



# Check for updates
# spry fetch  # Should turn back on but it take to long
# Run Spry Status
if [[ ${SPRY_MODE} == "development" ]]; then
    format warning "SPRY_MODE = ${SPRY_MODE}"
    echo ""
    spry status
    echo ""   
elif [[ ${SPRY_MODE} == "production" ]] || [[ ${SPRY_MODE} == "verbose" ]]; then
    updater check
    echo ""
elif [[ ${SPRY_MODE} == "fast" ]]; then
    # Nothing for fast loading... for now
fi



# Cleanup and/or Garbage collection (because sourced files retain vairables in the shell)
# unset total_todo total_functions total_comments total_aliases total_constants array_of_lines total_lines result

###############################################################################################
 ########  User Initialization functions - END                                          ########
  ###############################################################################################