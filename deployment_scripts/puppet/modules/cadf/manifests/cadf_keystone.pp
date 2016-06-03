class cadf::cadf_keystone {
  notice('MODULAR: cadf/cadf_keystone.pp')

  keystone_config {
      'DEFAULT/notification_format':  value => 'cadf';
  } ->
  Exec['restart_keystone']

  exec { 'restart_keystone':
    path        => ['/usr/sbin', '/usr/bin', '/sbin', '/bin/'],
    command     => "service apache2 restart",
  }

}
