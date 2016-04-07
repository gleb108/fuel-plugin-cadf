notice('MODULAR: cadf.pp')

$plugin_settings     = hiera('cadf')
$nova_enabled        = $plugin_settings['cadf-enable-nova']
$cinder_enabled      = $plugin_settings['cadf-enable-cinder']
$glance_enabled      = $plugin_settings['cadf-enable-glance']
$neutron_enabled     = $plugin_settings['cadf-enable-neutron']
$rados_enabled       = $plugin_settings['cadf-enable-rados']
$cadf_collector_url  = $plugin_settings['cadf-collector-url']

if $cadf_collector_url {
  class { 'cadf::cadf_ceilometer':
    cadf_collector_url => $cadf_collector_url,
  }
}
if $nova_enabled {
  class { 'cadf::cadf_nova': }
}
if $cinder_enabled {
  class { 'cadf::cadf_cinder': }
}
if $glance_enabled {
  class { 'cadf::cadf_glance': }
}
if $neutron_enabled {
  class { 'cadf::cadf_neutron': }
}
if $rados_enabled {
  class { 'cadf::cadf_rgwift': }
}

