#!/bin/bash

if [ ! -f /tls/ca/ca.pem ]; then
	mkdir -p /tls/ca
	cfssl print-defaults config > /tls/ca/ca-config.json
	cfssl print-defaults csr > /tls/ca/ca-csr.json
	cd /tls/ca
	cfssl genkey -initca ca-csr.json | cfssljson -bare ca
	cd
fi

exec $@

