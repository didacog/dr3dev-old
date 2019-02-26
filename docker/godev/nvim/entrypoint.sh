#!/bin/bash
set -e

#if [ "$1" = 'bash' ]; then
#fi

if [ ! -x /usr/local/go/bin/go ]; then
	# Install Golang
	GOLANG_VERSION=1.12
	ARCH=amd64 
	url="https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz"

	echo "Installing Golang ${GOLANG_VERSION} ..." 

	#set -eux
	curl -fLo go.tgz "$url" 
	#echo "${goRelSha256} *go.tgz" | sha256sum -c - && \
	sudo tar -C /usr/local -xzf go.tgz 
	rm go.tgz &&
	export PATH="/usr/local/go/bin:$PATH"

else
	echo "Skipping ... Go already installed!! ;)" 
fi

if [ -f "$HOME"/dots/custom/init.vim ]; then
	mkdir -p ${HOME}/.config/nvim; ln -s ${HOME}/dots/custom/init.vim ${HOME}/.config/nvim/init.vim
else
	[ -f "$HOME"/dots/init.vim ] && mkdir -p ${HOME}/.config/nvim; ln -s ${HOME}/dots/init.vim ${HOME}/.config/nvim/init.vim
fi

if [ -f "$HOME"/dots/custom/tmux.conf ]; then
	ln -s ${HOME}/dots/custom/tmux.conf ${HOME}/.tmux.conf
else
	[ -f "$HOME"/dots/tmux.conf ] && ln -s ${HOME}/dots/tmux.conf ${HOME}/.tmux.conf
fi

[ -f "$HOME"/dots/bash/bashrc ] && ln -sf ${HOME}/dots/bash/bashrc ${HOME}/.bashrc
[ -f "$HOME"/dots/bash/bash_profile ] &&  ln -sf ${HOME}/dots/bash/bash_profile ${HOME}/.bash_profile; 
[ -f "$HOME"/dots/bash/inputrc ] &&  ln -sf ${HOME}/dots/bash/inputrc ${HOME}/.inputrc; 
[ -d "$HOME"/dots/bash ] && ln -sf ${HOME}/dots/bash ${HOME}/.bash

touch ${HOME}/.bash_history

# Install Vim Plugins + vim-go binaries
#curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
nvim --headless +qall 
nvim --headless +PlugInstall +qall 
nvim --headless +PlugInstall +UpdateRemotePlugins +qall 
nvim --headless +GoInstallBinaries +qall

go get github.com/sourcegraph/go-langserver

if [ -f ${HOME}/go/dr3env.ghuser ]; then
	user=$(cat ${HOME}/go/dr3env.ghuser)
	workdir="${HOME}/go/src/github.com/${user}"
	mkdir -vp ${workdir}
	for repo in common cli agent core
	do
		if [ ! -d ${workdir}/drlm-${repo}/.git ]; then
			git clone https://github.com/${user}/drlm-${repo} ${workdir}/drlm-${repo} && \
				cd ${workdir}/drlm-${repo} && \
				git remote add upstream https://github.com/brainupdaters/drlm-${repo} && \
				git config url."https://${user}@github.com".InsteadOf "https://github.com" && \
				git flow init -d && \
				cd
		else
			cd ${workdir}/drlm-${repo} && \
				git fetch upstream && \
				cd
		fi
	done
fi

exec "$@"

