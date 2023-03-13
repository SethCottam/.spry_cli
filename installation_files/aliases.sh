  ##############################################################################################
 ########  Aliases (User) - START                                                      ########
##############################################################################################
#
# Aliases
# Shortcut: @aliases, @alias
# Description - Shortcuts to directors, functions, single line (sometime multiple) bash, etc.
# Author - Seth Cottam
# Status - Awesome
#
# NOTES: Aliases in ZSH don't require a directory location to be prepended with cd to cd to it


##############################################################################################
####  Spry Aliases
##############################################################################################
alias refresh="_spry_refresh"


##############################################################################################
####  Misc Aliases - @misc
##############################################################################################
# alias mamp="cd /Applications/MAMP/htdocs/"
# alias kafka_server_start="tab 'cd $HOME/Development/kafka_2.11-2.1.0; ./bin/kafka-server-start.sh config/server.properties'"
# alias kafka_check="kafkacat -b localhost:9092 -L | grep 'brokers'"  # TODO: Move to @kafy
# alias gobash="exec bash --login"
# alias gozsh="zsh"
# alias cli-tools="cd $HOME/Development/cli-tools/"
# alias seed="cd $HOME/Development/cli-tools/projects.sh seed"
# alias back='cd "$OLDPWD"' # bd instead of cd for Back on Directory insted of Change Directory
# alias diffy="open -a 'Google Chrome' https://www.diffchecker.com/diff"
# alias millis="open -a 'Google Chrome' https://currentmillis.com/"
# alias key="format info '$HOME/.ssh/id_rsa.pub'; cat $HOME/.ssh/id_rsa.pub;"
# alias aliases="subl $SPRY_CLI_ROOT/spry_cli_custom/aliases.sh"
# alias github_settings="open -a 'Google Chrome' 'https://github.com/settings/notifications'"
# alias prom_local="open -a 'Google Chrome' 'http://localhost:8001'"
# alias usage="top"  # simple CLI tool for viewing system usage
# alias pretty_tail="results; tail -f $1 | jq"
# alias git_repos="find $HOME/ -name \".git\" -print"
# alias ports="sudo lsof -i -P -n | grep LISTEN"
# alias camera="open -a 'Photo Booth'"
# alias firefox="open -a firefox"
# alias documents="cd $HOME/Documents"
# alias development="cd $HOME/Development"
# alias ip="curl http://checkip.amazonaws.com/"


##############################################################################################
####  LAZY, supremely lazy Aliases - @lazy
##############################################################################################
# For when 7 characters is simply too big of a commitment
# alias ..="cd .."
# alias ...="cd ../.."
# alias ....="cd ../../.."
# alias .....="cd ../../../.."
# alias re="_spry_refresh fast"  # cause I'm super lazy
# alias clr="clearly"  # it was ever so slightly faster
# alias fpush="git push -f"  # Stop judging me!
# alias sublime="subl"  # The default for Sublime Text installed via Brew Cask
# alias docs="documents"
# alias dev="development"


# For common typos and mistypes
# alias refersh="_spry_refresh"  # cause I fat finger it and type refersh half the time
# alias activate_python="start_python"  # I can never remember this as "start"
# alias secret=key
# alias secrets=key


# Lasy Git aliases
# alias gst="git status"
# alias gdiff="git diff"


##############################################################################################
####  Time Aliases - @time
##############################################################################################
# Dealing with timestamps. Ain't nobody got time for that!
# alias epoch="gdate +%s.%N"
# alias epochof="gdate +%s.%N -d"
# alias itime="gdate -u +%FT%T.%3NZ"
# alias itimeat="gdate -u +%FT%T.%3NZ -d"


##############################################################################################
 ########  Aliases (User) - END                                                        ########
  ##############################################################################################