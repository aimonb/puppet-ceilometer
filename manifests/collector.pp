class ceilometer::collector (
  $enabled        = true,
  $package_ensure = true
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::collector_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
