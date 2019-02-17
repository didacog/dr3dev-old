#!/usr/bin/env bash


# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
#export IRC_CLIENT='irssi'

# Set Xterm/screen/Tmux title with only a short hostname/username.
# Uncomment this (or set SHORT_HOSTNAME/SHORT_USER to something else),
# Will otherwise fall back on $HOSTNAME/$USER.
#export SHORT_HOSTNAME=$(hostname -s)
#export SHORT_USER=${USER:0:8}
# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# History
export HISTCONTROL=${HISTCONTROL:-ignorespace:erasedups} # erase duplicates; alternative option: export HISTCONTROL=ignoredups
#export HISTCONTROL=ignoredups;
export HISTSIZE=50000000; # Larger bash history (allow 32³ entries; default is 500)
export HISTFILESIZE=$HISTSIZE;
# Make some commands not show up in history
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h:pony:pony add *:pony update *:pony save *:pony ls:pony ls *";

#if [[ $PROMPT ]]; then
#    export PS1="\[""$PROMPT""\]"
#fi

# Adding Support for other OSes
PREVIEW="less"

# Make vim the default editor
export EDITOR=/usr/bin/nvim;
#export TERMINAL="urxvt";
export TERM=xterm-256color

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X";

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

export DBUS_SESSION_BUS_ADDRESS
DBUS_SESSION_BUS_ADDRESS=unix:path=/var/run/user/$(id -u)/bus;

#export TODOTXT_DEFAULT_ACTION=ls

# hidpi for gtk apps
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
export QT_DEVICE_PIXEL_RATIO=2

# turn on go vendoring experiment
#export GO15VENDOREXPERIMENT=1

# Golang env vars
export GOPATH=$HOME/go

# NPM for global packages non-root
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules

# Set PATH
export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin:$GOPATH/bin

#export DOCKER_CONTENT_TRUST=1

# if it's an ssh session export GPG_TTY
#if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
#	GPG_TTY=$(tty)
#	export GPG_TTY
#fi

