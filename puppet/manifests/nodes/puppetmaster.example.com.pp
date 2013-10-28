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
}

