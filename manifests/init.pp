class ceilometer (
  $enabled                = true,
  $package_ensure         = true,

  $log_verbose            = "False",
  $log_debug              = "False",

  $metering_api_port        = 9000,
  $database_connection      = "mongodb://localhost:27017/ceilometer",

  $os_auth_type             = "keystone",
  $os_auth_host             = "localhost",
  $os_auth_port             = "35357",
  $os_auth_url              = "http://localhost:5000",
  $os_auth_tenant           = "service",
  $os_auth_user             = "ceilometer",
  $os_auth_password         = "ChangeMe",

  $periodic_interval        = "600"
  $control_exchange         = "ceilometer"
  $metering_secret          = "Changem3"
  $metering_topic           = "metering"
  $nova_control_exchange    = "nova"
  $glance_control_exchange  = "nova"
  $glance_registry_host     = "localhost"
  $glance_registry_port     = "9191"
  $cinder_control_exchange  = "cinder"
  $quantum_control_exchange = "quantum"

  $rabbit_host          = "localhost",
  $rabbit_port          = "5672",
  $rabbit_user          = "guest",
  $rabbit_password      = "guest",
  $rabbit_virtual_host  = "/",
) {
  include ceilometer::params

  Vcsrepo["ceilometer"] -> Ceilometer_config<||>

  validate_re($sql_connection, '(sqlite|mysql|posgres)|mongodb:\/\/(\S+:\S+@\S+\/\S+)?')

  case $sql_connection  {
    /mysql:\/\/\S+:\S+@\S+\/\S+/    {
      $database_connection = "python-mysqldb"
    }
    /postgres:\/\/\S+:\S+@\S+\/\S+/ {
      $database_connection = "python-psycopg2"
    }
    /mongodb:\/\/\S+:\S+@\S+\/\S+/ {
      $database_connection = "python-pymongo"
    }
    /sqlite:\/\// {
      $database_connection = "python-pysqlite2"
    }
    default {
      fail("Unsupported backend configured")
    }
  }

  package {$backend_package:
    ensure => present
  }

  file {"/etc/ceilometer":
    ensure  => directory,
    owner   => "ceilometer",
    group   => "root",
    mode    => 660,
    require => Vcsrepo["ceilometer"]
  }

  ceilometer_config {
    "DEFAULT/debug":                  value => $log_debug;
    "DEFAULT/verbose":                value => $log_verbose;

    "DEFAULT/metering_api_port":      value => $metering_api_port;
    "DEFAULT/database_connection":    value => $database_connection;

    "DEFAULT/os_auth_host":             value => $os_auth_host;
    "DEFAULT/os_auth_port":             value => $os_auth_host;
    "DEFAULT/os_auth_url":              value => $os_auth_host;
    "DEFAULT/os_auth_tenant":           value => $os_auth_host;
    "DEFAULT/os_auth_user":             value => $os_auth_host;
    "DEFAULT/os_auth_password":         value => $os_auth_host;

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
  }
}
