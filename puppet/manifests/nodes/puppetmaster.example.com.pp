node 'puppetmaster.example.com' {

  # Cron provider for EL.
  package { 'cronie':
     ensure => present,
  }

  # Puppet master and agent
  class { '::puppet':
    runinterval                => '5m',
    server                     => true,
    server_reports             => 'store',
    server_external_nodes      => '',
    server_manifest_path       => '/etc/puppet/manifests',
    server_common_modules_path => ['/etc/puppet/common-modules', '/etc/puppet/modules'],
  }

  # Puppet DB - Single Node Setup
  # See: https://forge.puppetlabs.com/puppetlabs/puppetdb

  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    puppetdb_version     => latest,
    database             => 'postgres',
    disable_ssl          => false,
    listen_address       => '0.0.0.0',
    listen_port          => 8080,
    ssl_listen_address   => $::clientcert,
    ssl_listen_port      => 8081,
    open_ssl_listen_port => true,
  }

  # Configure the puppet master to use puppetdb
  class { 'puppetdb::master::config':
    puppetdb_server         => $::clientcert,
    puppetdb_port           => 8081,
    manage_config           => true,
    manage_routes           => true,
    manage_storeconfigs     => true,
    manage_report_processor => true,
    enable_reports          => true,
    use_ssl                 => true,
    restart_puppet          => true,
  }

  Package['cronie'] -> Class['::puppet'] -> Class['puppetdb'] -> Class['puppetdb::master::config']
}
