#!/bin/bash
set -e

#if [ "$1" = 'bash' ]; then
#fi

if [ ! -x /usr/local/go/bin/go ]; then
	# Install Golang
	GOLANG_VERSION=1.12
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

if [ -f "$HOME"/dots/custom/tmux.conf ]; then
	ln -s ${HOME}/dots/custom/tmux.conf ${HOME}/.tmux.conf
else
	[ -f "$HOME"/dots/tmux.conf ] && ln -s ${HOME}/dots/tmux.conf ${HOME}/.tmux.conf
fi

[ -f "$HOME"/dots/bash/bashrc ] && ln -sf ${HOME}/dots/bash/bashrc ${HOME}/.bashrc
[ -f "$HOME"/dots/bash/bash_profile ] &&  ln -sf ${HOME}/dots/bash/bash_profile ${HOME}/.bash_profile; 
[ -f "$HOME"/dots/bash/inputrc ] &&  ln -sf ${HOME}/dots/bash/inputrc ${HOME}/.inputrc;
[ -d "$HOME"/dots/bash ] && ln -sf ${HOME}/dots/bash ${HOME}/.bash;
[ -f "$HOME"/dots/code/settings.json ] && mkdir -p "${HOME}/.config/Code - OSS/User" && ln -sf ${HOME}/dots/code/settings.json "${HOME}/.config/Code - OSS/User/settings.json"

touch ${HOME}/.bash_history

# Install VSCode extensions
code --install-extension ms-vscode.Go
code --install-extension lextudio.restructuredtext
code --install-extension tomphilbin.gruvbox-themes
code --install-extension vector-of-bool.gitflow
code --install-extension mads-hartmann.bash-ide-vscode

go get github.com/sourcegraph/go-langserver

if [ -f ${HOME}/go/dr3env.ghuser ]; then
	user=$(cat ${HOME}/go/dr3env.ghuser)
	workdir="${HOME}/go/src/github.com/${user}"
	mkdir -vp ${workdir}
	for repo in common cli agent core
	do
		git clone https://github.com/${user}/drlm-${repo} ${workdir}/drlm-${repo} && \
			cd ${workdir}/drlm-${repo} && \
			git flow init -d && \
			cd
	done
fi

exec "$@"

