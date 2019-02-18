FROM golang:1.11.5

MAINTAINER Didac Oliveira "didac@drlm.org"

ENV	DEBIAN_FRONTEND=noninteractive \ 
	DEBCONF_NONINTERACTIVE_SEEN=true 

RUN apt-get update -qq && \
	echo 'Installing OS dependencies' && \
	apt-get install -qq -y --fix-missing \
	apt-utils sudo locate locales tmux vim \ 
	&& \ 
	echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    #rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    updatedb && \
	locale-gen en_US.UTF-8 && \
	localedef -i en_US -f UTF-8 en_US.UTF-8

ARG MYUSERNAME=developer
ARG MYUID=1000
ARG MYGID=1000
ENV MYUSERNAME=${MYUSERNAME}\
	MYUID=${MYUID} \
	MYGID=${MYGID}

RUN echo 'Creating user: ${MYUSERNAME} wit UID $UID' && \
    mkdir -p /home/${MYUSERNAME} && \
    echo "${MYUSERNAME}:x:${MYUID}:${MYGID}:Developer,,,:/home/${MYUSERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${MYUSERNAME}:x:${MYGID}:" >> /etc/group && \
    sudo echo "${MYUSERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${MYUSERNAME} && \
    sudo chmod 0440 /etc/sudoers.d/${MYUSERNAME} && \
    sudo chown ${MYUSERNAME}:${MYUSERNAME} -R /home/${MYUSERNAME} 
	#&& \
    #sudo chown root:root /usr/bin/sudo && \
	#chmod 4755 /usr/bin/sudo

USER ${MYUSERNAME}

ENV LANG=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8
ENV HOME=/home/${MYUSERNAME}
ENV GOPATH=/home/${MYUSERNAME}/go
ENV PATH=$PATH:/home/${MYUSERNAME}/go/bin:/usr/local/go/bin
ENV TERM=xterm-256color

WORKDIR /home/${MYUSERNAME}

CMD ["bash"]
