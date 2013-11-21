#!/bin/sh

echo "**** BOOTSTRAPPING ****"

echo "Removing old versions of puppet and facter installed in this box."
yum remove -y puppet facter

echo "Installing some other useful utils."
yum install -y tree vim rsync

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
IPADDRESS=`facter ipaddress_eth1`
hostname ${FQDN}
echo "${IPADDRESS} ${FQDN} ${HOSTNAME}" >> /etc/hosts
sed -i -e "s/HOSTNAME=.*$/HOSTNAME=${FQDN}/" /etc/sysconfig/network

# Copy puppet manifests and modules to puppet install dir.
/vagrant/scripts/sync_manifests.sh

# Turn on autosign for all hosts
echo "*" > /etc/puppet/autosign.conf

# Can't be bothered adding iptables rules for now...
service iptables stop
chkconfig iptables off

# Initial puppet run
/vagrant/papply.sh

# Create keystore for puppet db (TODO: move this into the puppet node manifest)
/usr/sbin/puppetdb-ssl-setup

# Restart it all 
service puppetdb restart
service httpd restart
puppet agent -t

service puppetdb restart
service httpd restart
service puppet restart

echo "I am ${HOSTNAME} with ip address ${IPADDRESS}"

echo "**** BOOTSTRAP DONE. ****"
