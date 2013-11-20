node 'puppetboard.example.com' {

  $puppetmaster = "puppetmaster.example.com"

  # Cron provider for EL.
  package { 'cronie':
     ensure => present,
  }

  class { '::puppet':
  	runinterval => '5m',
  }

  Package['cronie'] -> Class['::puppet']

  # Exported resources
  include nagios::target::host
}
