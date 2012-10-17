class ceilometer::collector (
  $enabled        = $ceilometer::config::enabled,
  $package_ensure = $ceilometer::config::package_ensure
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::collector_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
