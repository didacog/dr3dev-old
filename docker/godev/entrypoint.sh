#!/bin/bash
set -e

echo "#####################"
echo "######## Starting the SSH daemon..."
echo "#####################"

sudo ssh-keygen -A
echo "HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key" | sudo tee -a /etc/ssh/sshd_config
nohup sudo /usr/sbin/sshd -D -e -f /etc/ssh/sshd_config&

echo "#####################"
echo "######## Setting up dotfiles ..."
echo "#####################"

if [ -f "$HOME"/dots/custom/init.vim ]; then
	mkdir -p ${HOME}/.config/nvim; ln -s ${HOME}/dots/custom/init.vim ${HOME}/.config/nvim/init.vim
else
	[ -f "$HOME"/dots/nvim/init.vim ] && mkdir -p ${HOME}/.config/nvim; ln -s ${HOME}/dots/nvim/init.vim ${HOME}/.config/nvim/init.vim
	[ -f "$HOME"/dots/nvim/coc-settings.json ] && ln -s ${HOME}/dots/nvim/coc-settings.json ${HOME}/.config/nvim/coc-settings.json
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

if [ ! -f "$HOME/go/offline" ]; then
	if [ ! -d "$HOME"/.vim/plugged/vim-go ]; then
		echo "#####################"
		echo "######## Installing NeoVim plugins ..."
		echo "#####################"
	# Install Vim Plugins + vim-go binaries
	#curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
		nvim --headless +qa
		nvim --headless +PlugInstall +qa
		nvim --headless "+CocInstall coc-json" +qa
		nvim --headless +GoInstallBinaries +qa
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
	go get -u github.com/saibing/bingo
fi

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
	workdir="${HOME}/go/src/github.com/brainupdaters"
	mkdir -vp ${workdir}
	for repo in drlm-common drlmctl drlm-agent drlm-core drlm-testing drlm-plugins
	do
		if [ ! -d ${workdir}/${repo}/.git ]; then
			git clone https://github.com/brainupdaters/${repo} ${workdir}/${repo}
			cd ${workdir}/${repo}
			git config url."https://${user}@github.com".InsteadOf "https://github.com"
			git remote rename origin upstream
			git remote add origin https://github.com/${user}/${repo}
			git flow init -d 1> /dev/null
			git checkout develop
			if [ "$repo" != "drlm-testing" ] && [ "$repo" != "drlm-plugins" ]; then
				GO111MODULE=on go mod tidy
			fi
			cd

		else
			cd ${workdir}/${repo}
			if [ "$repo" != "drlm-testing" ] && [ "$repo" != "drlm-plugins" ]; then
				GO111MODULE=on go mod tidy
			fi
			cd
		fi
	done
else
	echo "Missing github user information! ghuser not provided! no repo autoconfig will be done!"
fi

cd "$HOME"/go/src/github.com/brainupdaters

exec "$@"
