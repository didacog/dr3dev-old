#!/bin/bash
set -e

#if [ "$1" = 'bash' ]; then
#fi

if [ ! -x /usr/local/go/bin/go ]; then
	# Install Golang
	GOLANG_VERSION=1.11.5
	ARCH=amd64 
	url="https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz"

	#set -eux
	curl -fLo go.tgz "$url" 
	#echo "${goRelSha256} *go.tgz" | sha256sum -c - && \
	sudo tar -C /usr/local -xzf go.tgz 
	rm go.tgz &&
	export PATH="/usr/local/go/bin:$PATH"

else
	echo "Skipping ... Go already installed!! ;)" 
fi

[ -f "$HOME"/dots/init.vim ] && mkdir -p ${HOME}/.config/nvim; ln -s ${HOME}/dots/init.vim ${HOME}/.config/nvim/init.vim
[ -f "$HOME"/dots/tmux.conf ] && ln -s ${HOME}/dots/tmux.conf ${HOME}/.tmux.conf
[ -f "$HOME"/dots/bash/bashrc ] && ln -sf ${HOME}/dots/bash/bashrc ${HOME}/.bashrc
[ -f "$HOME"/dots/bash/bash_profile ] &&  ln -sf ${HOME}/dots/bash/bash_profile ${HOME}/.bash_profile; 
[ -d "$HOME"/dots/bash ] && ln -sf ${HOME}/dots/bash ${HOME}/.bash

# Install Vim Plugins + vim-go binaries
#curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
nvim --headless +qall 
nvim --headless +PlugInstall +qall 
nvim --headless +PlugInstall +UpdateRemotePlugins +qall 
nvim --headless +GoInstallBinaries +qall

exec "$@"

