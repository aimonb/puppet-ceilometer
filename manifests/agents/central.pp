class ceilometer::agents::central (
  $enabled        = true,
  $package_ensure = true
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::agent_central_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
