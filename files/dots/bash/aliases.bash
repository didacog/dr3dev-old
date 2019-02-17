#!/usr/bin/env bash

case $OSTYPE in
  darwin*)
    alias reload='source ~/.bash_profile'
    ;;
  *)
    alias reload='source ~/.bashrc'
    ;;
esac

# SSH connections force xterm-256color (for rxvt-unicode terminfo issues)
alias ssh='TERM=xterm-256color ssh'

# List directory contents
#alias ls="ls --color=auto"
alias ls='ls -hN --color=auto --group-directories-first'
alias sl=ls
#alias la='ls -AF'       # Compact view, show hidden
#alias ll='ls -al'
#alias l='ls -a'
#alias l1='ls -1'
#alias l="ls -lF ${colorflag}"
#alias la="ls -laF ${colorflag}"
#alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# colored grep
export GREP_COLOR='1;33'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias cls='clear'

alias edit="$EDITOR"
alias pager="$PAGER"

alias q='exit'

alias irc="${IRC_CLIENT:=irc}"

# Easier navigation
alias ..='cd ..'              # Go up one directory
alias cd..='cd ..'            # Common misspelling for going up one directory
alias ...='cd ../..'          # Go up two directories
alias ....='cd ../../..'      # Go up three directories
alias .....='cd ../../../..'  # Go up four directories
alias -- -='cd -'             # Go back

# Shortcuts
alias dl='cd ~/Downloads'
alias g='git'
alias gc='. /usr/local/bin/gitdate && git commit -v '
# Shell History
alias h='history'
# Directory
alias md='mkdir -p'
alias rd='rmdir'

# Shorten extract
alias xt='extract'

# Vim to Neovim
alias vi='nvim'
alias vim='nvim'
# sudo vim
alias svim='sudo nvim'

# Linux specific aliases
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Flush Directory Service cache
alias flush='dscacheutil -flushcache && killall -HUP mDNSResponder'

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Lock the screen (when going AFK)
alias afk='i3lock -c 000000'

# vhosts
alias hosts='sudo vim /etc/hosts'

# copy working directory
alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard'

# copy file interactive
alias cp='cp -i'

# move file interactive
alias mv='mv -i'

# untar
alias untar='tar -xvf'
