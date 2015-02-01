# Class: base::logging
#
#
class base::logging {
  class { 'rsyslog':
    ssl => true,
  }

  class { 'rsyslog::client':
    server    => 'logs.papertrailapp.com',
    port      => hiera('papertrail_port'),
    ssl_ca    => '/etc/papertrail-bundle.pem',
    log_local => true,
  }

  file { '/etc/papertrail-bundle.pem':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/base/papertrail-bundle.pem',
  }
}
