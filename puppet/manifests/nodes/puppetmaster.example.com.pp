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


  # Puppet DB - Single Node Setup
  # See: https://forge.puppetlabs.com/puppetlabs/puppetdb

  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    database       => 'postgres',
    disable_ssl    => true,
    listen_address => '0.0.0.0',
    listen_port    => 8080,
  }

  # Configure the puppet master to use puppetdb
  class { 'puppetdb::master::config':
    puppetdb_server => $::fqdn,
    puppetdb_port   => 8080,
    use_ssl         => false,
  }

  Package['cronie'] -> Class['::puppet'] -> Class['puppetdb'] -> Class['puppetdb::master::config']
}

