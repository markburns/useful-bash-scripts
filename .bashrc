# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

source ~/.git-completion.sh
case "$TERM" in
xterm*)
       PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
       ;;
*)
       PS1='\u@\h:\w$(__git_ps1 " (%s)")\$ '
       ;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias lah='ls -lah'
alias psa='ps aux | grep '

alias gb='git branch -a -v'
alias gs='git status'
alias gd='git diff'
alias gk='gitk --all &'
alias gc='git commit -m'
alias gpl='git pull '
alias gpsh='git push '
alias gph='git push '
alias gp='git push '
alias gpo='git push origin '
alias gpom='git push origin master '
alias gl='git log '
alias glp='git log -p'
alias grh='git reset --hard '

alias gf='git fetch '
alias ss='script/server '
alias sc='script/console '
alias sct='script/console test'
alias sg='script/generate '
alias sgm='script/generate migration '
alias rdbm='rake db:migrate '
alias rdbmtp='rake db:migrate; rake db:test:prepare '
alias sgc='script/generate rspec_controller '
alias tl='tail -f -n100 log/development.log &'
alias rr='rake routes | grep '
alias show_here='python -m SimpleHTTPServer & firefox "localhost:8000/"'
alias lsf='lsm -f'
alias rdbtp='rake db:test:prepare'
alias ttr='touch tmp/restart.txt'
alias sar='sudo apachectl restart'

function ga {
  if [ -z "$1" ]; then
    git add .
  else
    git add $1
  fi
}


function gca {
  git add .
  git commit -a -m $1
}

function gco {
  if [ -z "$1" ]; then
    git checkout master
  else
    git checkout $1
  fi
}




# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

os=`/usr/bin/uname`

#if [ "$os" = 'LINUX']; then
#  if [[ -s /home/mark/.rvm/scripts/rvm ]] ; then source /home/mark/.rvm/scripts/rvm ; fi
#  rvm use 1.8.7
#fi

source ~/.cinderella.profile
