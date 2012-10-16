class ceilometer (
  $enabled                  = $ceilometer::config::enabled,
  $package_ensure           = $ceilometer::config::package_ensure,
  $verbose                  = $ceilometer::config::verbose,
  $debug                    = $ceilometer::config::debug,
  $metering_api_port        = $ceilometer::config::metering_api_port,
  $database_connection      = $ceilometer::config::database_connection,
  $auth_type                = $ceilometer::config::auth_type,
  $auth_host                = $ceilometer::config::auth_host,
  $auth_port                = $ceilometer::config::auth_port,
  $auth_url                 = $ceilometer::config::auth_url,
  $auth_tenant              = $ceilometer::config::auth_tenant,
  $auth_user                = $ceilometer::config::auth_user,
  $auth_password            = $ceilometer::config::auth_password,
  $periodic_interval        = $ceilometer::config::periodic_interval,
  $control_exchange         = $ceilometer::config::control_exchange,
  $metering_secret          = $ceilometer::config::metering_secret,
  $metering_topic           = $ceilometer::config::metering_topic,
  $nova_control_exchange    = $ceilometer::config::nova_control_exchange,
  $glance_control_exchange  = $ceilometer::config::glance_control_exchange,
  $glance_registry_host     = $ceilometer::config::glance_registry_host,
  $glance_registry_port     = $ceilometer::config::glance_registry_port,
  $cinder_control_exchange  = $ceilometer::config::cinder_control_exchange,
  $quantum_control_exchange = $ceilometer::config::quantum_control_exchange,
  $rabbit_host              = $ceilometer::config::rabbit_host,
  $rabbit_port              = $ceilometer::config::rabbit_port,
  $rabbit_user              = $ceilometer::config::rabbit_user,
  $rabbit_password          = $ceilometer::config::rabbit_password,
  $rabbit_virtual_host      = $ceilometer::config::rabbit_virtual_host
) inherits ceilometer::config {
  include ceilometer::params

  require "git"

  Vcsrepo["ceilometer"] -> Ceilometer_config<||>

  validate_re($database_connection, '(sqlite|mysql|posgres)|mongodb:\/\/(\S+:\S+@\S+\/\S+)?')

  case $database_connection  {
    /mysql:\/\/\S+:\S+@\S+\/\S+/: {
      $backend_package = "python-mysqldb"
    }
    /postgres:\/\/\S+:\S+@\S+\/\S+/: {
      $backend_package = "python-psycopg2"
    }
    /mongodb:\/\/(\S+:\S+@|)\S+\/\S+/: {
      $backend_package = "python-pymongo"
    }
    /sqlite:\/\//: {
      $backend_package = "python-pysqlite2"
    }
    default: {
      fail("Unsupported backend configured")
    }
  }

  package {$backend_package:
    ensure => present
  }

  user {"ceilometer":
    comment => "Ceilometer user",
    home    => $::ceilometer::params::install_dir,
    shell   => "/bin/bash",
  }

  group {"ceilometer":
    require => User["ceilometer"]
  }

  file {"ceilometer-etc":
    name    => "/etc/ceilometer",
    ensure  => directory,
    owner   => $::ceilometer::params::user,
    group   => "root",
    mode    => 660,
    require => [Vcsrepo["ceilometer"], User["ceilometer"], Group["ceilometer"]]
  }

  file {"ceilometer-var":
    name    => "/var/log/ceilometer",
    ensure  => directory,
    owner   => $::ceilometer::params::user,
    group   => $::ceilometer::params::group,
    mode    => 660,
    require => [Vcsrepo["ceilometer"], User["ceilometer"], Group["ceilometer"]]
  }

  ceilometer_config {
    "DEFAULT/debug":                  value => $debug;
    "DEFAULT/verbose":                value => $verbose;

    "DEFAULT/metering_api_port":      value => $metering_api_port;
    "DEFAULT/database_connection":    value => $database_connection;

    "DEFAULT/os_auth_host":             value => $auth_host;
    "DEFAULT/os_auth_port":             value => $auth_port;
    "DEFAULT/os_auth_url":              value => $auth_url;
    "DEFAULT/os_auth_tenant":           value => $auth_tenant;
    "DEFAULT/os_auth_user":             value => $auth_user;
    "DEFAULT/os_auth_password":         value => $auth_password;

    "DEFAULT/periodic_interval":        value => $periodic_interval;
    "DEFAULT/control_exchange":         value => $control_exchange;
    "DEFAULT/metering_secret":          value => $metering_secret;
    "DEFAULT/metering_topic":           value => $metering_topic;
    "DEFAULT/nova_control_exchange":    value => $nova_control_exchange;
    "DEFAULT/glance_control_exchange":  value => $glance_control_exchange;
    "DEFAULT/glance_registry_host":     value => $glance_registry_host;
    "DEFAULT/glance_registry_port":     value => $glance_registry_port;
    "DEFAULT/cinder_control_exchange":  value => $cinder_control_exchange;
    "DEFAULT/quantum_control_exchange": value => $quantum_control_exchange;

    "DEFAULT/rabbit_host":          value => $rabbit_host;
    "DEFAULT/rabbit_port":          value => $rabbit_port;
    "DEFAULT/rabbit_user":          value => $rabbit_user;
    "DEFAULT/rabbit_password":      value => $rabbit_password;
    "DEFAULT/rabbit_virtual_host":  value => $rabbit_virtual_host;
  }

  vcsrepo {"ceilometer":
    name     => $::ceilometer::params::install_dir,
    owner    => $::ceilometer::params::user,
    group    => $::ceilometer::params::group,
    ensure   => present,
    provider => git,
    require  => [Package["git"], User["ceilometer"]],
    source   => $::ceilometer::params::source,
    revision => $::ceilometer::params::revision
  }

  exec {"ceilometer-install":
    name    => "python setup.py develop",
    cwd     => $::ceilometer::params::install_dir,
    path    => [$::ceilometer::params::install_dir, "/usr/bin", "/usr/sbin"],
    require => Vcsrepo["ceilometer"]
  }
}
