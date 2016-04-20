class cadf::cadf_rgwift {
  notice('MODULAR: cadf/cadf_rgwift.pp')

  service {'rgwift':        }

  $nodes_hash = hiera('nodes')
  $controller_roles = ['primary-controller', 'controller',]
  $controller_mgmt_ips  = nodes_with_roles($nodes_hash, $controller_roles, 'internal_address')

  $public_vip  = hiera('public_vip')
  $internal_virtual_ip = hiera('management_vip')

  $ssl_hash          = hiera_hash('use_ssl', {})
  $public_ssl_hash   = hiera('public_ssl')
  $public_ssl_path   = get_ssl_property($ssl_hash, $public_ssl_hash, 'cadf', 'public', 'path', [''])

  $current_node_hash = hiera('node')
  $current_mgmt_ip = $current_node_hash['network_roles']['management']

  $rabbit_hash = hiera('rabbit')
  $rabbit_password = $rabbit_hash['password']
  $swift_hash = hiera('swift')
  $admin_password = $swift_hash['user_password']

  $rabbit_hosts = hiera('amqp_hosts')

  Openstack::Ha::Haproxy_service {
    internal_virtual_ip => $internal_virtual_ip,
    public_virtual_ip  => $public_vip,
  }

  class { 'cadf::firewall': port => '7070',
  } ->
  openstack::ha::haproxy_service { 'radosgw':
    order                  => '130',
    listen_port            => 8080,
    balancermember_port    => 7070,
    server_names           => $controller_mgmt_ips,
    ipaddresses            => $controller_mgmt_ips,
    public                 => true,
    internal               => true,
    public_ssl             => $public_ssl_hash,
    public_ssl_path        => $public_ssl_path,
    haproxy_config_options => { 'balance'        => 'roundrobin',
                                'mode'           => 'tcp', },
    balancermember_options => 'check',
  } ->
  package { 'rgwift':
    ensure       => present,
  } ->
  file { '/etc/swift':
    ensure => 'directory',
    path   => '/etc/swift',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  } ->
  file {'/etc/swift/swift.conf':
    path    => '/etc/swift/swift.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cadf/swift.conf.tmpl.erb'),
  }
  file {'/etc/rgwift/rgwift-server.conf':
    path    => '/etc/rgwift/rgwift-server.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('cadf/rgwift-server.conf.tmpl.erb'),
    notify  => Service['rgwift'],
  }

}
