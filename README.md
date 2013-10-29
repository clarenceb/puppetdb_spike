PuppetDB and Puppet Master Spike
================================

First: `vagrant up` to build the VM instance.
Then: `vagrant ssh` to access the VM instance.

The `provision.sh` script will be run automatically.

On the VM:

    cd /vagrant
    sudo ./papply.sh

On your host:

* Open a browser to `http://localhost:8080`

Further steps:

* Create some puppet agents and register them with the master so that the puppet DB can collect some useful node data.

Note:

* You maybe have to run `sudo ./papply.sh` two or three times due to the way the puppetdb module works - you will see some connection errors (it is eventually consistent though).

Puppet Modules used:
--------------------

puppet module install theforeman/foreman -i puppet/modules
puppet module install theforeman/puppet -i puppet/modules
puppet module install puppetlabs/puppetdb -i puppet/modules
