class cadf::cadf_cinder  {
    notice('MODULAR: cadf/cadf_cinder.pp')

    $ini_file       = '/etc/cinder/api-paste.ini'
    $audit_map_file = '/etc/pycadf/cinder_api_audit_map.conf'


    service {'cinder-api':        }

    Ini_setting {
      ensure  => present,
      section => 'filter:audit',
      path    => $ini_file,
    }

    ini_setting {'cinder1':
      ensure  => present,
      section => 'filter:audit',
      setting => 'paste.filter_factory',
      value   => 'keystonemiddleware.audit:filter_factory',
    } ->
    ini_setting {'cinder2':
      ensure  => present,
      section => 'filter:audit',
      setting => 'audit_map_file',
      value   => $audit_map_file,
    } ->
    ini_setting {'cinder_keystone_v1':
      ensure  => present,
      section => 'composite:openstack_volume_api_v1',
      setting => 'keystone',
      value   => 'request_id faultwrap sizelimit osprofiler authtoken keystonecontext audit apiv1',
    } ->
    ini_setting {'cinder_keystone_nolimit_v1':
      ensure  => present,
      section => 'composite:openstack_volume_api_v1',
      setting => 'keystone_nolimit',
      value   => 'request_id faultwrap sizelimit osprofiler authtoken keystonecontext audit apiv1',
    } ->
    ini_setting {'cinder_keystone_v2':
      ensure  => present,
      section => 'composite:openstack_volume_api_v2',
      setting => 'keystone',
      value   => 'request_id faultwrap sizelimit osprofiler authtoken keystonecontext audit apiv2',
    } ->
    ini_setting {'cinder_keystone_nolimit_v2':
      ensure  => present,
      section => 'composite:openstack_volume_api_v2',
      setting => 'keystone_nolimit',
      value   => 'request_id faultwrap sizelimit osprofiler authtoken keystonecontext audit apiv2',
      notify  => Service['cinder-api'],
    }

}


