  ##############################################################################################
 ########  Mini-README - START                                                         ########
##############################################################################################
#
# Until the account is fully seperated from the personal git history the publically avaiable
# version will be a packaged version containing no real git history. 
# 
# Alternatively it will contain only a single initial commit containing the version number
# and the most recent version of the code.
#
# Optional Development Instructions
# - source /Users/sethcottam/.spry_cli/system/packager.sh; packager
#
# run `packager` and it does everything
# 
##############################################################################################
 ########  Mini-README - END                                                           ########
  ##############################################################################################


  ###############################################################################################
 ########  Packager Functions - START                                                   ########
###############################################################################################
#
# Spry Packager
# Description - Through used of system temporary directories, it clones a "Personal" repo, removes all git records locally, initializes a new git repo, creates a single commit with the version number, and pushes it to a publically available repo.
#   Alternatively it will contain only a single initial commit containing the version number
#   and the most recent version of the code.
# Author - Seth Cottam
# Version - 1.0.0
# Status - Operational


function packager() {

    if [[ -n ${1} ]] && [[ ${1} == "help" ]]; then
        _packager_help
    else
        format info "Starting" partial
        format spry partial
        format info " packager ${SPRY_CLI_CUSTOM_ROOT_DIRECTORY}/"

        format debug1 "SPRY_PERSONAL_REPOSITORY" ${SPRY_PERSONAL_REPOSITORY}  # Input location
        format debug1 "SPRY_PACKAGE_REPOSITORY_URL" ${SPRY_PACKAGE_REPOSITORY_URL}  # Output location 

        # TODO: Build better. Immediately terminiate if the temp dir is unable to be created
        local temp_directory="$(mktemp -d)" || exit

        echo $temp_directory

        if [[ -d "$temp_directory" ]]; then

            # _packager_create_temp_directory $temp_directory
            cd $temp_directory
            _packager_clone_repository
            cd .spry_cli
            _packager_disconnect_repository
            git init  # Cannot seem to get this to work inside a sub function... weird. _packager_setup_local()
            _packager_initial_commit
            _packager_connect_package_repository
            _packager_force_push

        else 
             format error "Unable to create a temporary directory, please try again using sudo"
            _packager_failure
        fi

        format success "Packager process complete!"
        format spry partial
        format info " version $(cat version.txt) is now available at ${SPRY_PACKAGE_REPOSITORY_URL}/"
    fi
}

function _packager_help() {
    local temp_source=${${family}:u}_SOURCE

    echo ""
    format info "Packager help"
    format casual "This function family in an example for other function families"
    format debug1 "Packager Preperation" ""
    format debug2 " - Update code" ""
    format debug2 " - Update you version file" ""
    format debug2 " - Commit and Push Changes" ""
    format debug2 " - Log into the remote repo to create pull request and approve it" ""
    format debug1 "Run the packager" "packager"
    format warning "Make sure the version at the end matches what you expected it to be!"
    echo ""

    format info "Packager examples"
    _packager_examples
    format debug1 "Previous Usage" "hist functions ${family}"  # TODO: this should be an improved function in hist that would show unique functions
    echo ""
}

# TODO: Move theis over to the help since it's not really example
function _packager_examples() {  # {{TEMPLATE_CHILD_FUNCTION_NAME}}
    # List of usage examples
    format debug1 "Packager Help" "packager help"
    format debug1 "Run the packager" "packager"
}


function _packager_create_temp_directory() {
    format info "Creating temp directory"

    if [[ -n ${1} ]]; then

        if [[ -d "$1" ]]; then
            format warning "${temp_directory} already exists"
        else
            local result=$(mkdir $temp_directory 2>&1)

            if [[ ! -d "$temp_directory" ]]; then
                format error "Unable to create ${temp_directory} please try again with" partial
                format unique "sudo"
                packager_failure
            else
                format success "Created temporary directory for packaging ${temp_directory}"
            fi
            
        fi
        
    else 
        format error "_packager_create_temp_directory() requires a temporary directory to be passed to it"
        _packager_failure

    fi
}

function _packager_clone_repository() {
    format info "Cloning repository"
    echo "SPRY_PERSONAL_REPOSITORY = ${SPRY_PERSONAL_REPOSITORY}"  # Input location
    git clone ${SPRY_PERSONAL_REPOSITORY}
    # TODO: Needs an actual verification check
    if [[ -d ".spry_cli" ]]; then
        format success "Spry Personal repository cloned"
    else
        format error "There was an issue with cloning the git repository"
        _packager_failure
    fi
}

function _packager_disconnect_repository() {
    format info "Disconnecting \"original\" repository"
    if [[ -d ".git" ]]; then
        rm -rf .git
    else
        format error "Unable to locate the .git directory for removal. For safety the Packager has been stopped"
        _packager_failure
    fi
}

function _packager_setup_local() {
    format info "Setting up local git"
    result=$(git init)
    
    format success "Setup local"
}

function _packager_initial_commit() {
    version=$(cat version.txt)
    git add .
    git commit -m "Version ${version}"
    git log --oneline
}

function _packager_connect_package_repository() {
    format info "Connecting \"Package\" repository"
    git remote add origin ${SPRY_PACKAGE_REPOSITORY_URL}
    git remote -v
    # TODO: Need to validate this
    format success "Package repository connected"
}

function _packager_force_push () {
    format info "Attempting Packager repository update"
    git push --set-upstream origin master --force
    # TODO: Need to validate this
    format success "Package pushed to the repository"
}


function _packager_failure() {
    format error "Packaging process abandoned"
    exit 1
}

###############################################################################################
 ########  Packager Functions - END                                                     ########
  ###############################################################################################