#!/bin/sh

echo "**** BOOTSTRAPPING ****"

echo "Removing old versions of puppet and facter installed in this box."
yum remove -y puppet facter

echo "Installing some other useful utils."
yum install -y tree vim

echo "Adding puppetlabs EL6 yum repo."
rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm

echo "Adding EPL repo."
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

echo "Adding mod_passenger RPM repo."
rpm --import http://passenger.stealthymonkeys.com/RPM-GPG-KEY-stealthymonkeys.asc

echo "Installing the latest version of puppet and facter."
yum install -y puppet facter

echo "Configuring host name."
HOSTNAME=puppetmaster
DOMAIN=example.com
FQDN="${HOSTNAME}.${DOMAIN}"
IPADDRESS=`facter ipaddress`
hostname ${FQDN}
echo "${IPADDRESS} ${FQDN} ${HOSTNAME}" >> /etc/hosts
sed -i -e "s/HOSTNAME=.*$/HOSTNAME=${FQDN}/" /etc/sysconfig/network

echo "I am ${HOSTNAME} with ip address ${IPADDRESS}"

echo "**** BOOTSTRAP DONE. ****"

