class ceilometer::api (
  $enabled        = $ceilometer::config::enabled,
  $package_ensure = $ceilometer::config::package_ensure
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::api_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
