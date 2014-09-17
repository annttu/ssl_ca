#!/bin/bash

function usage
{
	echo "$0 fqdn"
	exit 1
}

[ "$1" == "" ] && usage

name="$1"

[ ! -d "$1" ] && echo "Not such directory $name" && exit 1

openssl ca -config openssl.cnf -revoke ${name}/${name}.crt
openssl ca -gencrl -config openssl.cnf -out ca/crl/crl.pem

echo "Copy ca/crl/crl.pem to proper location in www-root"
