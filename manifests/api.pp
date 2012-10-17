class ceilometer::api (
  $enabled              = true,
  $package_ensure       = true,
  $metering_api_port    = 9000
) inherits ceilometer {
  ceilometer_config {
    "DEFAULT/metering_api_port":           value => $metering_api_port
  }

  ceilometer::upstart {$::ceilometer::params::api_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
