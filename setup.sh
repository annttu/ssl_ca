#!/bin/bash

if [ ! -d "ca/" ]
then
	echo "Cannot find ca directory, exiting";
	exit 1
fi

if [ -f ca/ca.crt ]
then
	echo 'Setup already done.!'
	exit 1
fi


# Create private key
echo "Creating private key, generate strong password for it and keep it safe"
#openssl genrsa -aes256 -out ca/ca.key 4096
#chmod 400 ca/ca.key
echo "Generating certificate"

read -p "Common name: " MyCommonName
read -p "Coyntry Code: " MyCountryCode
read -p "State or province: " MyState
read -p "City: " MyLocality
read -p "Company: " MyCompany
read -p "Unit: " MyUnit
read -p "CRL server address: " MyCrlPoint

cat openssl.cnf.template |sed \
  -e "s/MyCountryCode/$MyCountryCode/g" \
  -e "s/MyState/$MyState/g" \
  -e "s/MyLocality/$MyLocality/g" \
  -e "s/MyCompany/$MyCompany/g" \
  -e "s/MyUnit/$MyUnit/g" \
  -e "s/MyCrlPoint/$MyCrlPoint/g" \
  -e "s/MyCommonName/$MyCommonName/g" > openssl.cnf

#openssl req -new -x509 -days 1825 -key ca/ca.key -out ca/ca.crt -config openssl.cnf


