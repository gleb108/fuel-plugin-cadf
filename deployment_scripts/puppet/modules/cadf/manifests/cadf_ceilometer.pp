class cadf::cadf_ceilometer ($cadf_collector_url) {
  notice('MODULAR: cadf/cadf_ceilometer.pp')

  $config         = '/etc/ceilometer/ceilometer.conf'

  service {'ceilometer-collector':        }
  service {'ceilometer-agent-notification':        }


  Ini_setting {
    ensure  => present,
    section => 'dispatcher_http',
    path    => $config,
  }

  file {'/etc/ceilometer/event_pipeline.yaml':
    path    => '/etc/ceilometer/event_pipeline.yaml',
    owner   => 'ceilometer',
    group   => 'ceilometer',
    mode    => '0644',
    content => template('cadf/event_pipeline.yaml.tmpl.erb'),
  } ->

  exec {'Adding additional dispatchers to ceilometer.conf':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "sed -i 's|^\\[DEFAULT\\]|\\[DEFAULT\\]\\n\\ndispatcher = database\\ndispatcher = http|' \
    ${config}",
    unless  => "grep -q '^dispatcher\s*=\s*database' ${config}",
  } ->

  ini_setting {'target':
    ensure  => present,
    section => 'dispatcher_http',
    setting => 'target',
    value   => $cadf_collector_url
  } ->
  ini_setting {'cadf_only':
    ensure  => present,
    section => 'dispatcher_http',
    setting => 'cadf_only',
    value   => false,
    notify  => Service['ceilometer-collector', 'ceilometer-agent-notification'],
  }

}
