# From: http://docs.puppetlabs.com/guides/exported_resources.html
class nagios::monitor {
    $nagios_packages = [ 'nagios',
                         'nagios-plugins',
                         'nagios-plugins-ping',
                         'nagios-plugins-load',
                         'nagios-plugins-users',
                         'nagios-plugins-http',
                         'nagios-plugins-ssh',
                         'nagios-plugins-disk',
                         'nagios-plugins-swap',
                         'nagios-plugins-procs' ]

    package { $nagios_packages:
        ensure => installed,
    }

    file { ['/etc/nagios/nagios_host.cfg', '/etc/nagios/nagios_service.cfg']:
       ensure   => file,
       require  => Package['nagios'],
    }

    service { 'nagios':
      ensure    => running,
      enable    => true,
      #subscribe => File[$nagios_cfgdir], 
      require   => Package['nagios'],
    }

    # Collect resources and populate /etc/nagios/nagios_*.cfg
    Nagios_host <<||>> {
        notify => Service['nagios'],
    }
    Nagios_service <<||>> {
        notify => Service['nagios'],
    }
}
