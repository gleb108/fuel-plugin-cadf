class cadf::cadf_neutron {

    notice('MODULAR: cadf/cadf_neutron.pp')

    $ini_file       = '/etc/neutron/api-paste.ini'
    $audit_map_file = '/etc/pycadf/neutron_api_audit_map.conf'

    service {'neutron-server':        }

    Ini_setting {
      ensure  => present,
      section => 'filter:audit',
      path    => $ini_file,
    }

    ini_setting {'neutron1':
      ensure  => present,
      section => 'filter:audit',
      setting => 'paste.filter_factory',
      value   => 'keystonemiddleware.audit:filter_factory',
    } ->
    ini_setting {'neutron2':
      ensure  => present,
      section => 'filter:audit',
      setting => 'audit_map_file',
      value   => $audit_map_file,
    } ->
    ini_setting {'neutron_keystone':
      ensure  => present,
      section => 'composite:neutronapi_v2_0',
      setting => 'keystone',
      value   => 'request_id catch_errors authtoken keystonecontext extensions audit neutronapiapp_v2_0',
      notify  => Service['neutron-server'],
    }

}


