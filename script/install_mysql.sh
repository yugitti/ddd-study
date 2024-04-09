#!/bin/sh

mkdir /usr/install
chmod 777 /usr/install

mv mysql-8.3.0-1.el7.x86_64.rpm-bundle.tar /usr/install
cd /usr/install

tar -xvf mysql-8.3.0-1.el7.x86_64.rpm-bundle.tar

cd /usr/install

yum localinstall -y mysql-community-common-8.3.0* \
   mysql-community-client-plugins-8.3.0* \
   mysql-community-libs-8.3.0* \
   mysql-community-libs-compat-8.3.0* \
   mysql-community-devel-8.3.0* \
   mysql-community-client-8.3.0* \
   mysql-community-icu-data-files-8.3.0* \
   mysql-community-server-8.3.0*