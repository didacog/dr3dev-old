#!/bin/bash

certname=$1  

mkdir -vp ${PWD}/files/tls/$certname

if [ ! -f ${PWD}/files/tls/$certname/$certname.json ]; then
	# Generate Certificate
	curl -d '{ "request": {"CN": "'$certname'","hosts":["'$certname'"], "key": { "algo": "rsa","size": 2048 }, "names": [{"C":"US","ST":"California", "L":"San Francisco","O":"example.com"}]}}' http://0.0.0.0:8888/api/v1/cfssl/newcert > ${PWD}/files/tls/$certname/$certname.json
	# Create Private Key file
	echo -en "$(cat ${PWD}/files/tls/$certname/$certname.json | python -m json.tool | grep private_key | cut -f4 -d '"')" > ${PWD}/files/tls/$certname/$certname.key
	# Create Certificate file
	echo -en "$(cat ${PWD}/files/tls/$certname/$certname.json | python -m json.tool | grep -m 1 certificate | cut -f4 -d '"')" > ${PWD}/files/tls/$certname/$certname.crt

	if [ "$certname" == "minio" ]; then
		mv ${PWD}/files/tls/$certname/$certname.key ${PWD}/files/tls/$certname/private.key
		mv ${PWD}/files/tls/$certname/$certname.crt ${PWD}/files/tls/$certname/public.crt
	fi
fi

