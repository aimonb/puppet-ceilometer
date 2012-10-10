class ceilometer::agents::central (
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::agent_central_name:
    enabled => $enabled
  }
}
