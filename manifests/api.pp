class ceilometer::api (
) inherits ceilometer {
  $svc_name = $::ceilometer::params::api_name
  
  ceilometer::upstart {$svc_name:
    enabled => $enabled
  }
}
