# syntax = docker/dockerfile:experimental

FROM archlinux/base:latest AS builder

RUN pacman -Syy && pacman --needed --noconfirm -S sudo git bash-completion tmux code otf-fira-code \
	autoconf automake binutils bison fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make patch pkgconf sed texinfo util-linux which && \
	useradd --shell /bin/bash --home-dir /build -m builder && \
	echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder && \
	chmod 0440 /etc/sudoers.d/builder && \
#	sudo -u builder bash -c 'cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -s --noconfirm && mv yay*.pkg.tar.xz yay.pkg.tar.xz' && \
	sudo -u builder bash -c 'cd ~ && git clone https://aur.archlinux.org/gitflow-avh.git gitflow && cd gitflow && makepkg -si --noconfirm && mv gitflow*.pkg.tar.xz gitflow-avh.pkg.tar.xz' && \
	sudo -u builder bash -c 'cd ~ && git clone https://aur.archlinux.org/gitflow-bashcompletion-avh.git gitflow-bc && cd gitflow-bc && makepkg -s --noconfirm && mv gitflow*.pkg.tar.xz gitflow-bc-avh.pkg.tar.xz'
#	sudo -u builder bash -c 'cd ~ && git clone https://aur.archlinux.org/visual-studio-code-bin.git vscode && cd vscode && makepkg -s --noconfirm && mv visual*.pkg.tar.xz vscode.pkg.tar.xz'

## Install Golang
#ENV GOLANG_VERSION=1.11.5 \
#	ARCH=amd64 
#
#RUN set -eux; \
#	url="https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz" && \
#	curl -fLo go.tgz "$url" && \
#	#echo "${goRelSha256} *go.tgz" | sha256sum -c - && \
#	tar -C /usr/local -xzf go.tgz && \
#	rm go.tgz && \
#	export PATH="/usr/local/go/bin:$PATH" && \
#	go version

FROM archlinux/base:latest

LABEL maintainer Didac Oliveira "didac@drlm.org"

# Install software
COPY --from=builder /build/*/*.pkg.tar.xz /tmp
#COPY --from=builder /usr/local/go /usr/local/go

RUN --mount=type=bind,from=builder,source=/var/cache/pacman,target=/var/cache/pacman --mount=type=bind,from=builder,source=/var/lib/pacman/sync,target=/var/lib/pacman/sync \
#	pacman -Sy && \
	pacman --needed --noconfirm -S sudo git bash-completion gzip tar tmux code otf-fira-code && \
#	autoconf automake binutils bison fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make patch pkgconf sed texinfo util-linux which && \
#	pacman --noconfirm -U /tmp/yay.pkg.tar.xz && \
	pacman --noconfirm -U /tmp/gitflow-avh.pkg.tar.xz && \
	pacman --noconfirm -U /tmp/gitflow-bc-avh.pkg.tar.xz && \
#	pacman --noconfirm -U /tmp/vscode.pkg.tar.xz && \
	#sudo -u ${MYUSER} bash -c 'yay --needed --noconfirm -S gitflow-avh gitflow-bashcompletion-avh' && \
    rm -rf /tmp/* && \
	pacman -Scc && \
	locale-gen en_US.UTF-8 && \
	localedef -i en_US -f UTF-8 en_US.UTF-8

# Create User
ARG MYUSER=developer
ARG	MYUID=1000
ARG	MYGID=1000

ENV MYUSER=${MYUSER}\
	MYUID=${MYUID} \
	MYGID=${MYGID} \
	LANG=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	HOME=/home/${MYUSER} \
	GOPATH=/home/${MYUSER}/go \
	PATH=/home/${MYUSER}/go/bin:/usr/local/go/bin:$PATH \
	TERM=xterm-256color

RUN	groupadd --gid ${MYGID} ${MYUSER} && \
	useradd --gid ${MYGID} --uid ${MYUID} --home-dir /home/${MYUSER} -m --shell /bin/bash ${MYUSER} && \
	echo "${MYUSER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${MYUSER} && \
	chmod 0440 /etc/sudoers.d/${MYUSER} && \
	mkdir -p "$GOPATH/src" "$GOPATH/bin" && chown -R ${MYUSER}:${MYUSER} "$GOPATH"

#COPY files/init.vim /home/${MYUSER}/.config/nvim/init.vim
#COPY files/tmux.conf /home/${MYUSER}/.tmux.conf
COPY entrypoint.sh /usr/local/bin/

#RUN sudo -u ${MYUSER} bash -c 'nvim --headless +PlugInstall +UpdateRemotePlugins +qall && nvim --headless  +GoInstallBinaries +qall'

USER ${MYUSER}
WORKDIR /home/${MYUSER}
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "bash" ]
