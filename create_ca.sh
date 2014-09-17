#!/bin/bash

if [ ! -d "ca/" ]
then
	echo "Cannot find ca directory, exiting";
	exit 1
fi

if [ -f ca/ca.crt ]
then
	echo "Ca.crt already exists"
	exit 1
fi


openssl genrsa -aes256 -out ca/ca.key 4096
chmod 400 ca/ca.key
openssl req -new -x509 -days 3650 -key ca/ca.key -out ca/ca.crt -config openssl.cnf


