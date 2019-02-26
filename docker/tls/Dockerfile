FROM alpine:latest

LABEL maintainer Didac Oliveira "didac@drlm.org"

# Create User
ARG MYUSER=developer
ARG	MYUID=1000
ARG	MYGID=1000
ARG ARCH=amd64

ENV MYUSER=${MYUSER}\
	MYUID=${MYUID} \
	MYGID=${MYGID} \
	LANG=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	HOME=/home/${MYUSER} \
	GOPATH=/home/${MYUSER}/go \
	PATH=$GOPATH/bin:/usr/local/go/bin:$PATH \
	TERM=xterm-256color

RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf && \
	apk --no-cache add \
	ca-certificates openssl \
	sudo bash curl busybox && \
	update-ca-certificates && \
	rm -rf /var/cache/apk/* && \
	curl -LO https://pkg.cfssl.org/R1.2/cfssl-bundle_linux-${ARCH} -LO https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-${ARCH} -LO https://pkg.cfssl.org/R1.2/cfssl-newkey_linux-${ARCH} \
	-LO https://pkg.cfssl.org/R1.2/cfssl-scan_linux-${ARCH} -LO https://pkg.cfssl.org/R1.2/cfssl_linux-${ARCH} -LO https://pkg.cfssl.org/R1.2/cfssljson_linux-${ARCH} \
	-LO https://pkg.cfssl.org/R1.2/mkbundle_linux-${ARCH} -LO https://pkg.cfssl.org/R1.2/multirootca_linux-${ARCH} && \
	chmod 755 cfssl-bundle_* && mv cfssl-bundle_* /usr/local/bin/cfssl-bundle && \
	chmod 755 cfssl-certinfo_* && mv cfssl-certinfo_* /usr/local/bin/cfssl-certinfo && \
	chmod 755 cfssl-newkey_* && mv cfssl-newkey_* /usr/local/bin/cfssl-newkey && \
	chmod 755 cfssl-scan_* && mv cfssl-scan_* /usr/local/bin/cfssl-scan && \
	chmod 755 cfssl_* && mv cfssl_* /usr/local/bin/cfssl && \
	chmod 755 cfssljson_* && mv cfssljson_* /usr/local/bin/cfssljson && \
	chmod 755 mkbundle_* && mv mkbundle_* /usr/local/bin/mkbundle && \
	chmod 755 multirootca_* && mv multirootca_* /usr/local/bin/multirootca && \
	addgroup -S -g ${MYGID} ${MYUSER} && \
    adduser -S -u ${MYUID} -g ${MYGID} -s /bin/bash ${MYUSER}

#RUN cfssl print-defaults config > ca-config.json && cfssl print-defaults csr > ca-csr.json && \
#	cfssl genkey -initca ca-csr.json | cfssljson -bare ca

COPY entrypoint.sh /usr/local/bin/

USER ${MYUSER}

WORKDIR /home/${MYUSER}

EXPOSE 8888

ENTRYPOINT ["entrypoint.sh"]

CMD ["cfssl","serve","-ca=/tls/ca/ca.pem","-ca-key=/tls/ca/ca-key.pem","-address=0.0.0.0"]
