#!/bin/sh

echo "Syncing puppet manifest..."

if [ $EUID != 0 ]
then
   echo "Please run this script as root."
   exit 1
fi

HOSTNAME=`hostname`

if [ "${HOSTNAME}" != "puppetmaster.example.com" ]
then
   echo "This script should be run on ${HOSTNAME}"
   exit 1
fi 

mkdir -p /etc/puppet/manifests
mkdir -p /etc/puupet/modules
mkdir -p /etc/puppet/common-modules

rsync -vur --delete /vagrant/puppet/manifests/ /etc/puppet/manifests
rsync -vur --delete /vagrant/puppet/modules/ /etc/puppet/modules
rsync -vur --delete /vagrant/puppet/common-modules/ /etc/puppet/common-modules

chown -R puppet:puppet /etc/puppet/manifests /etc/puupet/modules /etc/puppet/common-modules

echo "Finished syncing puppet manifests."
