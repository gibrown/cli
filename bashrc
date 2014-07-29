#!/bin/bash

# If not running interactively, don't do anything:
[ -z "$PS1" ] && return

SYSTYPE='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   SYSTYPE='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   SYSTYPE='Darwin'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   SYSTYPE='freebsd'
fi


#----------------------------------------
# Bash options
#----------------------------------------

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob        # Necessary for programmable completion.

# Disable options:
shopt -u mailwarn
unset MAILCHECK         # Don't want my shell to warn me of incoming mail.

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#disable audible bell
set bell-style visible

#----------------------------------------
# Common Key mappings
#----------------------------------------

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
bind '"\e[1;5C":forward-word'
bind '"\e[1;5D": backward-word'
bind '"\e[5C": forward-word'
bind '"\e[5D": backward-word'
bind '"\e\e[C": forward-word'
bind '"\e\e[D": backward-word'

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:lsl:hi"
export EDITOR="emacs -q"

#-------------------------------------------------------------
# Path Configs
#-------------------------------------------------------------

#mostly need to be handled locally

#----------------------------------------------
#Expanded Path info
#----------------------------------------------
PATH=/Applications/MAMP/bin/php/php5.4.4/bin:${PATH}:/Developer/Simulator/GTKwave/bin:~/pear/bin

#-------------------------------------------------------------
# Greeting, motd etc...
#-------------------------------------------------------------

# Define some colors first:
red='\033[0;31m'
RED='\033[1;31m'
blue='\033[0;34m'
BLUE='\033[1;34m'
cyan='\033[0;36m'
CYAN='\033[1;36m'
grey='\033[0;37m'
NC='\033[0m'              # No Color
# --> Nice. Has the same effect as using "ansi.sys" in DOS.

# Looks best on a terminal with black background.....
echo -e "${CYAN}This is BASH ${RED}${BASH_VERSION%.*}\
${CYAN} - DISPLAY on ${RED}$HOSTNAME${NC}\n"
date

#-------------------------------------------------------------
# Shell Prompt and Title
#-------------------------------------------------------------

PS1='\[\033[1;31m\][\!]\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

#-------------------------------------------------------------
# File Listing
#-------------------------------------------------------------

export LS_OPTIONS='--color=auto'

if [[ $SYSTYPE == "Darwin" ]]; then
    alias ls='ls -FG'
    alias la='ls -aG'
    alias lsl='ls -ltrFG'
    alias lsa='ls -altrFG'
else
    alias ls='ls -FG --color=auto'
    alias la='ls -aG --color=auto'
    alias lsl='ls -ltrFG --color=auto'
    alias lsa='ls -altrFG --color=auto'
fi

#-------------------------------------------------------------
# Screen and Tmux
#-------------------------------------------------------------

alias s="screen -d -R -U"
alias t="tmux a -t work"

#-------------------------------------------------------------
# History
#-------------------------------------------------------------

alias hi='history'

function hig()
{
	history | grep "$*"
}

#-------------------------------------------------------------
# Version Control Config
#-------------------------------------------------------------

function svndiff() { svn diff $@ | colordiff | less -R ; }

alias sup='svn up --ignore-externals'
alias sst='svn st --ignore-externals'

alias gpr="git pull --rebase"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset %Cblue[%an]%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%Creset' --abbrev-commit"

alias gs="git status"
alias gd="git diff"
alias gp="git push"
alias ga="git add"
alias gr="git rebase"

#alias g-="git checkout -"
alias gh="git show HEAD"

#-------------------------------------------------------------
# Finding
#-------------------------------------------------------------

# grep ignoring .svn files
function vgrep() { grep -Iir --exclude-dir=blogs.dir --exclude-dir=.svn --exclude-dir=languages "$*" *; }
#function vgrep() { find . -type f \! -path *.svn* -print0 | xargs -0 grep "$*" ;}

# grep -l ignoring .svn files
function lsgrep() { find . -type f \! -path *.svn* -print0 | xargs -0 grep -l "$*" ; }

# find function definitions
#function fungrep { find . -type f \! -name *.svn* -print0 | xargs -0 egrep "^[[:space:]]*function.*?$1"; } # grep for fu$
function fungrep() { egrep -Iir --exclude-dir=blogs.dir --exclude-dir=.svn --exclude-dir=languages "^[[:space:]]*function.*?$1" *; }


#-------------------------------------------------------------
# Aliases
#-------------------------------------------------------------

alias clr='clear'
alias del='mv $* ~/.Trash/.'
alias x="exit"

alias build_tags='etags -l auto `find -iname "*.cpp"` `find -iname "*.h"` `find -iname "*.c"` `find -iname "*.hpp"`'

alias cpan='sudo perl -MCPAN -e shell'


function xtitle()      # Adds some text in the terminal frame.
{
    case "$TERM" in
	*term | rxvt)
	    echo -n -e "\033]0;$*\007" ;;
	*)
	    ;;
    esac
}

# aliases that use xtitle
alias top='xtitle "Processes on $HOSTNAME" && top'
alias make='xtitle Making $(basename $PWD) ; make'
alias ftp="xtitle FTP ; ftp"
alias ssh="xtitle SSH ; ssh"
alias scp="xtitle SCP ; scp"

# .. and functions
if [[ $SYSTYPE == "Darwin" ]]; then
    function man()
    {
	for i ; do
	    xtitle The $(basename $1|tr -d .[:digit:]) manual
	    command man -F -a "$i"
	done
    }
fi

# Shows your directory structure quite neatly..stolen from no other
# than Harald Hannelius himself :)
#
function tree()
{
    echo -e "\033[1;33m"

    (cd ${1-.} ; pwd)
    find ${1-.} -print | sort -f | sed     \
	\
	-e "s,^${1-.},,"                   \
	-e "/^$/d"                         \
	-e "s,[^/]*/\([^/]*\)$,\ |-->\1,"  \
	-e "s,[^/]*/, |   ,g"

    echo -e "\033[0m"
}


######################################################
# Useful Functions


function my_ip() # Get IP addresses.
{
    MY_IP=$(/sbin/ifconfig en1 | awk '/inet/ { print $2 } ' | \
sed -e s/addr://)
    MY_ISP=$(/sbin/ifconfig en1 | awk '/P-t-P/ { print $3 } ' | \
sed -e s/P-t-P://)
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on $HOSTNAME"
    echo -e "\nAdditionnal information: " ; uname -a
    echo -e "\n${RED}Users logged on: " ; w -h
    echo -e "\n${RED}Current date : " ; date
    echo -e "\n${RED}Machine stats : " ; uptime
#    echo -e "\n${RED}Memory stats : " ; free
    my_ip 2>&- ;
    echo -e "\n${RED}Local IP Address :" ; echo ${MY_IP:-"Not connected"}
    echo -e "\n${RED}Open connections : "; netstat -I e1 -an;
    echo
}
