Spry CLI - Command Line Tool
========================

MarkdownPreview
---------------

  <!-- For Github preview stuff -->
  <!-- [![Build][github-ci-image]][github-ci-link] -->
  <!-- [![Package Control Downloads][pc-image]][pc-link] -->
  <!-- ![License][license-image] -->

# Command Line Tool

## Overview

### TODO: List
	- Map out format
	- Build out the controller
		+ Refresh Tool
		+ Loader
	- Add plugins
	- Installation
		+ Needs to check to see if a user_settings.py exists. If not it needs to mv user_settings.example.sh to user_settings.sh. It CANNOT overwrite files!!!
		+ Install the ascii art command into the proper section
	- Format the README.md
  - Need to build out a CLI help response for Spry CLI
  - Should modify the ZSH to replace spry_cli with a colorized and underlined SpryCLI in OhMyZSH
  - Unit Tests
  - Clarificaiton of types of functions
    - Parents of familial functons
    - Children of familiam functions
    - Sub-Parents of familial functions
    - Free Form Functions (Non-familial, FFF, or efers)


### Sections
- Development (_specific to local development of this tool_)
- Installation (_for the local installation_)
- Output (_Controls how the output messages are formatted and colored_)
- Plugins (_For all the stuff we want it to be able to do_)
- System (_Core system shells that shouldn't be messed with and core shell dependancies_)




---

## Notes


#### Directories

+ development _This stores files specific to managing local development_
+ installation _Installation shells_
+ output _Shells for managing formatting and coloration of the Spry CLI terminal outputs_
+ safehouse _This is where you store secrets needed by your user settings and/or spryts. These ARE NOT tracked by git._
+ spryts _A play on Spry, this is where you store each individual script/plugin that you want to autoload into the Spry CLI_
+ system _System specific shells for managing the build and implementation of the Spry CLI_



#### Load Order
+ autoloader.sh
+ development/master_constroller.sh
  - Output shell scripts
  - Spryts shell scripts
  - System shell scripts
  - The remaining development shell scripts
  - User specific scripts



#### Git considerations
_For ignoring all future changes to a file AFTER this point_
_This is useful for initial config files that you expect a user to change_
`git update-index --skip-worktree path/DummyFile.txt`



#### Ascii Art Intro
I changed the plugins folder to spryts because I like the word play!


```
Ogre
 __                      ___   __   _____
/ _\_ __  _ __ _   _    / __\ / /   \_   \
\ \| '_ \| '__| | | |  / /   / /     / /\/
_\ \ |_) | |  | |_| | / /___/ /___/\/ /_
\__/ .__/|_|   \__, | \____/\____/\____/
   |_|         |___/


Small
  ___                  ___ _    ___
 / __|_ __ _ _ _  _   / __| |  |_ _|
 \__ \ '_ \ '_| || | | (__| |__ | |
 |___/ .__/_|  \_, |  \___|____|___|
     |_|       |__/


Standard
  ____                      ____ _     ___
 / ___| _ __  _ __ _   _   / ___| |   |_ _|
 \___ \| '_ \| '__| | | | | |   | |    | |
  ___) | |_) | |  | |_| | | |___| |___ | |
 |____/| .__/|_|   \__, |  \____|_____|___|
       |_|         |___/


Colossal

 .d8888b.  Put some pep in your step       .d8888b.  888      8888888
d88P  Y88b          with                  d88P  Y88b 888        888
Y88b.                                     888    888 888        888
 "Y888b.   88888b.  888d888 888  888      888        888        888
    "Y88b. 888 "88b 888P"   888  888      888        888        888
      "888 888  888 888     888  888      888    888 888        888
Y88b  d88P 888 d88P 888     Y88b 888      Y88b  d88P 888        888
 "Y8888P"  88888P"  888      "Y88888       "Y8888P"  88888888 8888888
           888                   888
           888              Y8b d88P
           888               "Y88P"


Cygnet

.-.            .-.  -.-
`-..-..-.. .  (  |   |
`-'|-''  '-|   `-'-'-'-
   '     `-'


Swan

 .-.                 .--..    --.--
(   )               :    |      |
 `-. .,-. .--..  .  |    |      |
(   )|   )|   |  |  :    |      |
 `-' |`-' '   `--|   `--''---'--'--
     |           ;
     '        `-'

/sprī/ adjective Active; lively.
```


Full Logo
```
  .d8888b.  Put some pep in your step       .d8888b.  888      8888888
 d88P  Y88b          with the              d88P  Y88b 888        888
 Y88b.                                     888    888 888        888
  "Y888b.   88888b.  888d888 888  888      888        888        888
     "Y88b. 888 "88b 888P"   888  888      888        888        888
       "888 888  888 888     888  888      888    888 888        888
 Y88b  d88P 888 d88P 888     Y88b 888      Y88b  d88P 888        888
  "Y8888P"  88888P"  888      "Y88888       "Y8888P"  88888888 8888888
    Y888888 888 88888888888888888 888 8888888888888888888888888888888Y
     "Y8888 888 Y88888888888 Y8b d88P 88888888888888888888888888888Y"
       Y888 888L Y8888888888."Y88P".888888888888888888888888888888Y
```


Handling arg options

You can pass multiple arrays as arguments using something like this:
```bash
takes_ary_as_arg()
{
    declare -a argAry1=("${!1}")
    echo "${argAry1[@]}"

    declare -a argAry2=("${!2}")
    echo "${argAry2[@]}"
}
try_with_local_arys()
{
    # array variables could have local scope
    local descTable=(
        "sli4-iread"
        "sli4-iwrite"
        "sli3-iread"
        "sli3-iwrite"
    )
    local optsTable=(
        "--msix  --iread"
        "--msix  --iwrite"
        "--msi   --iread"
        "--msi   --iwrite"
    )
    takes_ary_as_arg descTable[@] optsTable[@]
}
try_with_local_arys
```

will echo:
```bash
sli4-iread sli4-iwrite sli3-iread sli3-iwrite
--msix  --iread --msix  --iwrite --msi   --iread --msi   --iwrite
```


#### Brand new mac install

Might want to allow for an unprotected prer

+ Setup SSH Key (Then add in the remote repo)... might just do this as a password the first time then switch to ssh. Or might allow the prerunner to be a public repo?
+ Needs to install mac developer tools. (Dependancy for a git install)
+ git clone ... (Spry CLI needs to be the old repo)
+ Needs an installer for .zsh to append the autoloader to the .zshrc file



#### Tag Lines
+ The best answers include Y  # (kafy, kubey,)
+ Embrace the power of Y
+ Always start with whY. Run it through Spry
+ When you understand whY you'll run with SrpyCLI
+ When you understand the power of whY you'll run with SrpyCLI
  - Kafy
  - Kubey
+ Put some pep in your step with



#### Inspiration for an auto-updater from Oh My ZSH
```
Last login: Tue Apr  7 17:49:43 on ttys013
[Oh My Zsh] Would you like to update? [Y/n]: Y
Updating Oh My Zsh
remote: Enumerating objects: 74, done.
remote: Counting objects: 100% (74/74), done.
remote: Compressing objects: 100% (34/34), done.
remote: Total 52 (delta 34), reused 36 (delta 18), pack-reused 0
Unpacking objects: 100% (52/52), done.
From https://github.com/ohmyzsh/ohmyzsh
 * branch            master     -> FETCH_HEAD
   4d1202c..d647423  master     -> origin/master
 lib/completion.zsh                                     |  2 +-
 lib/functions.zsh                                      |  2 +-
 lib/misc.zsh                                           | 20 ++++++++++----------
 lib/spectrum.zsh                                       | 26 ++++++++++++--------------
 plugins/battery/battery.plugin.zsh                     |  6 +++---
 plugins/colored-man-pages/README.md                    |  3 +++
 plugins/colored-man-pages/colored-man-pages.plugin.zsh |  7 +++++--
 plugins/gnu-utils/gnu-utils.plugin.zsh                 |  2 +-
 plugins/keychain/keychain.plugin.zsh                   |  3 +++
 plugins/systemd/systemd.plugin.zsh                     |  2 +-
 plugins/themes/themes.plugin.zsh                       |  2 +-
 themes/nebirhos.zsh-theme                              |  2 +-
 12 files changed, 42 insertions(+), 35 deletions(-)
First, rewinding head to replay your work on top of it...
Fast-forwarded master to d6474237b823448b3a1dd176a246ed73a30494f9.
         __                                     __
  ____  / /_     ____ ___  __  __   ____  _____/ /_
 / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \
/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / /
\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/
                        /____/
Hooray! Oh My Zsh has been updated and/or is at the current version.
To keep up on the latest news and updates, follow us on twitter: https://twitter.com/ohmyzsh
Get your Oh My Zsh swag at: https://shop.planetargon.com/collections/oh-my-zsh
```



#### Package Management
_General Ideas - Very much a work in progress_

Each file is their own sub_repo ie_spry/spryts/spryt_name?

Spry CLI should be it's own repo
The spryts are individual

Switch to git pull only, running on production

We need to create a spryts whitelist rather than a .ignore based blakclist
  - We should probably have a blanket .ignore for the ENITRE Spryts directory
  - We should add a config (to add additional )

shallow clone
https://stackoverflow.com/questions/13750182/git-how-to-archive-from-remote-repository-directly

sparse-checkout
https://github.blog/2020-01-17-bring-your-monorepo-down-to-size-with-sparse-checkout/

# TODO: We might descide to set a trigg on Changes not staged for commit:, Untracked files:, and Ignored files: instead of checking each line by line

if [[ $SPRY_MODE == "development" ]]; then