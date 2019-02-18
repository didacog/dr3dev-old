FROM minio/minio:latest

# Create User
ARG MYUSER=developer
ARG	MYUID=1000
ARG	MYGID=1000

ENV MYUSER=${MYUSER} \
	MYUID=${MYUID} \
	MYGID=${MYGID}

RUN addgroup -S -g ${MYGID} ${MYUSER} && \
	adduser -S ${MYUSER} -u ${MYUID} -g ${MYGID} -s /bin/bash -G users


EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

HEALTHCHECK --interval=30s --timeout=5s \
    CMD /usr/bin/healthcheck.sh

USER ${MYUSER}

WORKDIR /home/${MYUSER}

CMD ["minio"]
