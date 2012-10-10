class ceilometer::agents::compute (
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::agent_compute_name:
    enabled => $enabled
  }
}
