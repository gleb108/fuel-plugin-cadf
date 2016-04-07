class cadf::cadf_nova {
    notice('MODULAR: cadf/cadf_nova.pp')

    $ini_file       = '/etc/nova/api-paste.ini'
    $audit_map_file = '/etc/pycadf/nova_api_audit_map.conf'

    service {'nova-api':        }

    Ini_setting {
      ensure  => present,
      section => 'filter:audit',
      path    => $ini_file,
    }

    ini_setting {'nova1':
      ensure  => present,
      section => 'filter:audit',
      setting => 'paste.filter_factory',
      value   => 'keystonemiddleware.audit:filter_factory',
    } ->
    ini_setting {'nova2':
      ensure  => present,
      section => 'filter:audit',
      setting => 'audit_map_file',
      value   => $audit_map_file,
    } ->
    ini_setting {'nova_keystone':
      ensure  => present,
      section => 'composite:openstack_compute_api_v2',
      setting => 'keystone',
      value   => 'compute_req_id faultwrap sizelimit authtoken keystonecontext ratelimit audit osapi_compute_app_v2',
    } ->
    ini_setting {'nova_keystone_nolimit':
      ensure  => present,
      section => 'composite:openstack_compute_api_v2',
      setting => 'keystone_nolimit',
      value   => 'compute_req_id faultwrap sizelimit authtoken keystonecontext audit osapi_compute_app_v2',
      notify  => Service['nova-api'],
    }
}


