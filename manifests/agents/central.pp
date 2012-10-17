class ceilometer::agents::central (
  $enabled        = $ceilometer::config::enabled,
  $package_ensure = $ceilometer::config::package_ensure
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::agent_central_name:
    enabled => $enabled,
    require => Exec["ceilometer-install"]
  }
}
