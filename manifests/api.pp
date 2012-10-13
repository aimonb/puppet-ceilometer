class ceilometer::api (
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::api_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
