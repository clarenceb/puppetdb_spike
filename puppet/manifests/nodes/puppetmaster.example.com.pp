node 'puppetmaster.example.com' {

  # Cron provider for EL.
  package { 'cronie':
     ensure => present,
  }

  # Puppet master and agent
  class { '::puppet':
    server                => true,
    server_reports        => 'store',
    server_external_nodes => '',
  }

  Package['cronie'] -> Class['::puppet']

  # Puppet DB - Single Node Setup
  # See: https://forge.puppetlabs.com/puppetlabs/puppetdb

  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    database => 'embedded',  # Don't use PostgreSQL (for testing purposes)
  }

  # Configure the puppet master to use puppetdb
  class { 'puppetdb::master::config': }
}

