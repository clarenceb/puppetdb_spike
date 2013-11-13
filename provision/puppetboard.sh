#!/bin/sh

echo "**** BOOTSTRAPPING ****"

echo "Adding EPL repo."
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

echo "Configuring host name."
HOSTNAME=puppetboard
DOMAIN=example.com
FQDN="${HOSTNAME}.${DOMAIN}"
IPADDRESS=`facter ipaddress_eth1`
hostname ${FQDN}
echo "${IPADDRESS} ${FQDN} ${HOSTNAME}" >> /etc/hosts
sed -i -e "s/HOSTNAME=.*$/HOSTNAME=${FQDN}/" /etc/sysconfig/network

# Can't be bothered adding iptables rules for now...
service iptables stop
chkconfig iptables off

# Puppetboard requirements
yum install -y python python-pip git 
git clone https://github.com/nedap/puppetboard
cd puppetboard
pip install -r requirements.txt

# Update configuration file
sed -i -e "s/PUPPETDB_HOST\s*=\s*'.*'/PUPPETDB_HOST = '192.168.33.10'/" puppetboard/default_settings.py
sed -i -e "s/DEV_LISTEN_HOST\s*=\s*'.*'/DEV_LISTEN_HOST = '0.0.0.0'/" puppetboard/default_settings.py

# Run dev version of web app in the background
echo "To start the puppetboard web app, run: nohup python dev.py &" 

echo "I am ${HOSTNAME} with ip address ${IPADDRESS}"

echo "**** BOOTSTRAP DONE. ****"
