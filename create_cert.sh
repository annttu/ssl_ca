#!/bin/bash

function usage
{
	echo "$0 [-u (server|router|user)] [-b bits] fqdn"
	exit 1
}

OPTIONS=""
CAOPTIONS=""

if [ "$1" == "-u" ] && [ "$2" != "" ]
then
	CAOPTIONS="-extensions ${2}_cert"
	shift
	shift
fi

if [ "$1" == "-b" ] && [ "$2" != "" ]
then
	OPTIONS="-newkey rsa:$2"
	shift
	shift
fi

[ "$1" != "" ] && name="$1" || usage
host="$name"

CONFIG="openssl.cnf"
CLIENT_CNF="client.cnf"

# uuden avaimen luominen
mkdir $name
cd $name
if [ ! -f "$name.key" ]
then
	cat ../$CLIENT_CNF |sed -e "s/commonName_default.*/commonName_default = ${host}/" > ${name}.cfg
	openssl req -new -config ${name}.cfg $OPTIONS -out $name.csr -keyout $name.key -batch || exit 1
fi
#if [ ! -f "${name}_passless.key" ]
#then
#	openssl rsa -in $name.key -out ${name}_passless.key || exit 1
#fi

cd ..

if [ ! -f "${name}.crt" ]
then
	openssl ca -config $CONFIG $CAOPTIONS -notext -out $name/$name.crt -infiles $name/${name}.csr || exit 1
	cd $name
	#mv ${name}_passless.key ${name}.key
	cp ../ca/ca.crt ca.crt
	echo "----- CERTIFICATE READY -----"
	echo "Private key: ${name}/${name}.key"
	echo "Public cert: ${name}/${name}.crt"
	echo "Ca cert:     ${name}/ca.crt"
fi
