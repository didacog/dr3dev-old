ARG MARIADB_VERSION

FROM mariadb:${MARIADB_VERSION}

ARG	MYUID=1000
ARG	MYGID=1000

ENV MYGID=${MYGID} \
	MYUID=${MYUID}

RUN groupmod -g ${MYGID} mysql &&\
	usermod -u ${MYUID} mysql &&\
	mkdir -vp /var/lib/mysql /var/run/mysqld &&\
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld &&\
	chmod 777 /var/run/mysqld

VOLUME /var/lib/mysql

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld"]

