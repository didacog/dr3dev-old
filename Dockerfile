FROM archlinux/base:latest

MAINTAINER Didac Oliveira "didac@drlm.org"

RUN pacman -Syu --noconfirm && \
	pacman --noconfirm -S sudo git curl wget gnupg bash-completion \
	autoconf automake binutils bison fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make patch pkgconf sed texinfo util-linux which \
	neovim python-neovim tmux && \
	#git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd  .. && rm -rf yay && \
    rm -rf /tmp/* && \
	locale-gen en_US.UTF-8 && \
	localedef -i en_US -f UTF-8 en_US.UTF-8

# Install Golang

ENV GOLANG_VERSION 1.11.5
ENV ARCH amd64 
RUN set -eux; \
	url="https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz"; \
	#wget -O go.tgz "$url"; \
	curl -fLo go.tgz "$url"; \
	#echo "${goRelSha256} *go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ARG MYUSERNAME=developer
ARG MYUID=1000
ARG MYGID=1000
ENV MYUSERNAME=${MYUSERNAME}\
	MYUID=${MYUID} \
	MYGID=${MYGID}

RUN groupadd --gid ${MYGID} ${MYUSERNAME} && \
	useradd --gid ${MYGID} --uid ${MYUID} --home-dir /home/${MYUSERNAME} -m --shell /bin/bash ${MYUSERNAME} && \
	echo "${MYUSERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${MYUSERNAME} && \
    chmod 0440 /etc/sudoers.d/${MYUSERNAME}

COPY files/init.vim /home/${MYUSERNAME}/.config/nvim/init.vim
COPY files/tmux.conf /home/${MYUSERNAME}/.tmux.conf

USER ${MYUSERNAME}

ENV LANG=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8
ENV HOME=/home/${MYUSERNAME}
ENV GOPATH=/home/${MYUSERNAME}/go
ENV PATH=$PATH:/home/${MYUSERNAME}/go/bin:/usr/local/go/bin
ENV TERM=xterm-256color

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chown -R ${MYUSERNAME}:${MYUSERNAME} "$GOPATH"

WORKDIR /home/${MYUSERNAME}

CMD ["bash"]
