class ceilometer::collector (
) inherits ceilometer {
  ceilometer::upstart {$::ceilometer::params::collector_name:
    enabled => $enabled
  }
}
