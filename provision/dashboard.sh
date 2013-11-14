#!/bin/sh

echo "**** BOOTSTRAPPING ****"

echo "Adding EPL repo."
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

echo "Configuring host name."
HOSTNAME=dashboard
DOMAIN=example.com
FQDN="${HOSTNAME}.${DOMAIN}"
IPADDRESS=`facter ipaddress_eth1`
hostname ${FQDN}
echo "${IPADDRESS} ${FQDN} ${HOSTNAME}" >> /etc/hosts
sed -i -e "s/HOSTNAME=.*$/HOSTNAME=${FQDN}/" /etc/sysconfig/network

# Can't be bothered adding iptables rules for now...
service iptables stop
chkconfig iptables off

# rbenv setup
yum install -y git
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
. ~/.bash_profile
type rbenv | grep -q "rbenv is a function" && echo "rbenv is now installed" || echo "rbenv failed to install correctly."

# Install Ruby 1.9.2 as the default ruby and run bundler
rbenv install 1.9.2-p320
rbenv rehash
cd /vagrant/dashboard/webapp
rbenv local 1.9.2-p320
echo "Ruby version `ruby -v` is now installed as the global default."
gem install bundler --no-ri --no-rdoc
rbenv rehash
bundle install
rbenv rehash

# Run dev version of web app in the background
echo "To start the dashboard web app, run: nohup dashing start &"

echo "I am ${HOSTNAME} with ip address ${IPADDRESS}"

echo "**** BOOTSTRAP DONE. ****"
