class cadf::cadf_glance {
    notice('MODULAR: cadf/cadf_glance.pp')

    $ini_file       = '/etc/glance/glance-api-paste.ini'
    $audit_map_file = '/etc/pycadf/glance_api_audit_map.conf'


    service {'glance-api':        }

    Ini_setting {
      ensure  => present,
      section => 'filter:audit',
      path    => $ini_file,
    }

    ini_setting {'glance1':
      ensure  => present,
      section => 'filter:audit',
      setting => 'paste.filter_factory',
      value   => 'keystonemiddleware.audit:filter_factory',
    } ->
    ini_setting {'glance2':
      ensure  => present,
      section => 'filter:audit',
      setting => 'audit_map_file',
      value   => $audit_map_file,
    } ->
    ini_setting {'pipeline1':
      ensure  => present,
      section => 'pipeline:glance-api',
      setting => 'pipeline',
      value   => 'versionnegotiation osprofiler unauthenticated-context audit rootapp',
    } ->
    ini_setting {'pipeline2':
      ensure  => present,
      section => 'pipeline:glance-api-caching',
      setting => 'pipeline',
      value   => 'versionnegotiation osprofiler unauthenticated-context cache audit rootapp',
    } ->
    ini_setting {'pipeline3':
      ensure  => present,
      section => 'pipeline:glance-api-cachemanagement',
      setting => 'pipeline',
      value   => 'versionnegotiation osprofiler unauthenticated-context cache cachemanage audit rootapp',
    } ->
    ini_setting {'pipeline4':
      ensure  => present,
      section => 'pipeline:glance-api-keystone',
      setting => 'pipeline',
      value   => 'versionnegotiation osprofiler authtoken context audit rootapp',
    } ->
    ini_setting {'pipeline5':
      ensure  => present,
      section => 'pipeline:glance-api-keystone+caching',
      setting => 'pipeline',
      value   => 'versionnegotiation osprofiler authtoken context cache audit rootapp',
    } ->
    ini_setting {'pipeline6':
      ensure  => present,
      section => 'pipeline:glance-api-keystone+cachemanagement',
      setting => 'pipeline',
      value   => 'versionnegotiation osprofiler authtoken context cache cachemanage audit rootapp',
    } ->
    ini_setting {'pipeline7':
      ensure  => present,
      section => 'pipeline:glance-api-trusted-auth',
      setting => 'pipeline',
      value   => 'versionnegotiation osprofiler context audit rootapp',
    } ->
    ini_setting {'pipeline8':
      ensure  => present,
      section => 'pipeline:glance-api-trusted-auth+cachemanagement',
      setting => 'pipeline',
      value   => 'versionnegotiation osprofiler context cache cachemanage audit rootapp',
      notify  => Service['glance-api'],
    }

}


