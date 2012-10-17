class ceilometer::agents::compute (
  $enabled        = true,
  $package_ensure = true
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::agent_compute_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
