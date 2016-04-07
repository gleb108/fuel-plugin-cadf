class cadf::firewall (
  $port,
) {
  notice('MODULAR: cadf/firewall.pp')
  package { 'iptables-persistent':
    ensure => installed,
  }
  ->
  firewall {'175 rgwift':
    port      => $port,
    proto     => 'tcp',
    action    => 'accept',
  }

}

