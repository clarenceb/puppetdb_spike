PuppetDB and Puppet Master Spike
================================

First: `vagrant up` to build the VM instance.
Then: `vagrant ssh` to access the VM instance.

The `provision.sh` script will be run automatically.

On the VM:

	sudo su
	# Note sure of the correct sequence but this seems to work ok.
	puppet agent -t
	restart service puppetdb
	restart service httpd
	restart service puppet


On your host:

* Open a browser to `http://192.168.33.10:8080`
* You should see the PuppetDB dashboard with 1 node

API test:

    # On the VM, type (remote HTTPS requires that you specify a certificate, a private key, and a CA certificate).
    curl -H "Accept: application/json" http://localhost:8080/facts/`hostname -f`

Further steps:

* Create some puppet agents and register them with the master so that the puppet DB can collect some useful node data.
* Get HTTPS API working for remote API requests
* Play around with the API endpoints

Puppet Modules used:
--------------------

* `puppet module install theforeman/foreman -i puppet/modules`
* `puppet module install theforeman/puppet -i puppet/modules`
* `puppet module install puppetlabs/puppetdb -i puppet/modules`
