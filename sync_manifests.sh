#!/bin/sh

mkdir -p /etc/puppet/manifests
mkdir -p /etc/puupet/modules
mkdir -p /etc/puppet/common-modules

rsync -vur --delete /vagrant/puppet/manifests/ /etc/puppet/manifests
rsync -vur --delete /vagrant/puppet/modules/ /etc/puppet/modules
rsync -vur --delete /vagrant/puppet/common-modules/ /etc/puppet/common-modules

chown -R puppet:puppet /etc/puppet/manifests /etc/puupet/modules /etc/puppet/common-modules
