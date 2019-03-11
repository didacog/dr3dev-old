#!/bin/bash
set -e

#if [ "$1" = 'bash' ]; then
#fi

if [ ! -x /usr/local/go/bin/go ]; then
	# Install Golang
	GOLANG_VERSION=1.11.5
	ARCH=amd64 
	url="https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz"

	echo "#####################"
	echo "######## Installing Golang ${GOLANG_VERSION} ..." 
	echo "#####################"

	#set -eux
	curl -fLo go.tgz "$url" 
	#echo "${goRelSha256} *go.tgz" | sha256sum -c - && \
	sudo tar -C /usr/local -xzf go.tgz 
	rm go.tgz
	export PATH="/usr/local/go/bin:$PATH"

else
	echo "#####################"
	echo "######## Skipping ... Go already installed!! ;)" 
	echo "#####################"
fi

if [ ! -x /usr/local/protoc/bin/protoc ]; then
	# Install Protobuffers
	PROTO_VERSION=3.6.1
	ARCH=x86_64
	url="https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/protoc-${PROTO_VERSION}-linux-${ARCH}.zip"

	echo "#####################"
	echo "Installing Protocol buffers ${PROTO_VERSION} ..." 
	echo "#####################"

	curl -fLo proto.zip "$url" 
	sudo unzip -d /usr/local/protoc proto.zip
	rm proto.zip
	export PATH="/usr/local/protoc/bin:$PATH"
else
	echo "#####################"
	echo "######## Skipping ... Protobuffers already installed!! ;)" 
	echo "#####################"
fi


echo "#####################"
echo "######## Setting up dotfiles ..."
echo "#####################"

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
[ -f "$HOME"/dots/code/settings.json ] && mkdir -p "${HOME}/.config/Code - OSS/User" && ln -sf ${HOME}/dots/code/settings.json "${HOME}/.config/Code - OSS/User/settings.json"

touch ${HOME}/.bash_history

#export GO111MODULE=on

if [ ! -d "$HOME"/.vim/plugged/vim-go ]; then
	echo "#####################"
	echo "######## Installing NeoVim plugins ..."
	echo "#####################"
# Install Vim Plugins + vim-go binaries
#curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	nvim --headless +qall 
	nvim --headless +PlugInstall +qall 
	nvim --headless +PlugInstall +UpdateRemotePlugins +qall 
	nvim --headless +GoInstallBinaries +qall
else
	echo "#####################"
	echo "######## Skipping ... NeoVim plugins already installed!!! ;)"
	echo "#####################"
fi

if [ ! -d "$HOME"/.vscode-oss/extensions ]; then
	echo "#####################"
	echo "######## Installing VSCode extensions ..."
	echo "#####################"
# Install VSCode extensions
	code --install-extension ms-vscode.Go
	code --install-extension lextudio.restructuredtext
	code --install-extension tomphilbin.gruvbox-themes
	code --install-extension vector-of-bool.gitflow
	code --install-extension mads-hartmann.bash-ide-vscode
else
	echo "#####################"
	echo "######## Skipping ... VSCode extensions already installed!!! ;)"
	echo "#####################"
fi

echo "#####################"
echo "######## Installing/Updating Go & Bash Language servers ..."
echo "#####################"

# Install bash language server
export npm_config_prefix=${HOME}/.node_modules
npm i -g bash-language-server
go get -v -u github.com/sourcegraph/go-langserver

echo "#####################"
echo "######## Installing/Updating DRLMv3 Go deps ..."
echo "#####################"

go get -v google.golang.org/grpc
go get -v github.com/spf13/cobra/cobra
go get -v github.com/Sirupsen/logrus
go get -v github.com/golang/protobuf/protoc-gen-go
## drlm upstream libs
go get -v github.com/brainupdaters/drlm-core
go get -v github.com/brainupdaters/drlm-cli
go get -v github.com/brainupdaters/drlm-common/comms
go get -v github.com/brainupdaters/drlm-common/logger
go get -v github.com/brainupdaters/drlm-agent

echo "#####################"
echo "######## Setting up Git/GitFlow & drlm v3 repos ..."
echo "#####################"

if [[ -f ${HOME}/go/dr3env.gitname && -f ${HOME}/go/dr3env.gitmail ]]; then
	name=$(cat ${HOME}/go/dr3env.gitname)
	mail=$(cat ${HOME}/go/dr3env.gitmail)
	echo "[user]" > ${HOME}/.gitconfig
	echo "name = ${name}" >> ${HOME}/.gitconfig
	echo "email = ${mail}" >> ${HOME}/.gitconfig
else
	echo "Missing ${HOME}/.gitconfig information! gitname & gitmail not provided!"
fi

if [ -f ${HOME}/go/dr3env.ghuser ]; then
	user=$(cat ${HOME}/go/dr3env.ghuser)
	workdir="${HOME}/go/src/github.com/${user}"
	mkdir -vp ${workdir}
	for repo in common cli agent core
	do
		if [ ! -d ${workdir}/drlm-${repo}/.git ]; then
			git clone https://github.com/${user}/drlm-${repo} ${workdir}/drlm-${repo} && \
				cd ${workdir}/drlm-${repo} && \
				git config url."https://${user}@github.com".InsteadOf "https://github.com" && \
				git remote add upstream https://github.com/brainupdaters/drlm-${repo} && \
				git fetch upstream && \
				git flow init -d -p 'feature/' -b 'bugfix/' -r 'release/' -x 'hotfix/' -s 'support/' && \
				GO111MODULE=on go mod tidy && \
				cd
		else
			cd ${workdir}/drlm-${repo} && \
				git fetch upstream && \
				GO111MODULE=on go mod tidy && \
				cd
		fi
	done
else
	echo "Missing github user information! ghuser not provided! no repo autoconfig will be done!"
fi

cd "$HOME"

exec "$@"
