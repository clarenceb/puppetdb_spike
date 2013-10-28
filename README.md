Puppet Master and Puppet DB Demo
================================

First: `vagrant up` to build the VM instance.
Then: `vagrant ssh` to access the VM instance.

Puppet Modules used:
--------------------

puppet module install theforeman/foreman -i puppet/modules
puppet module install theforeman/puppet -i puppet/modules
puppet module install puppetlabs/puppetdb -i puppet/modules
