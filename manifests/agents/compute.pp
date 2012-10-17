class ceilometer::agents::compute (
  $enabled        = $ceilometer::config::enabled,
  $package_ensure = $ceilometer::config::package_ensure
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::agent_compute_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
