Plugin CADF
============
Intended to implement CADF notification to main OpenStack services.
More info about Cloud Auditing Data Federation (CADF):
https://www.dmtf.org/standards/cadf

Openstack core services (Nova, Cinder, Glance and Neutron use
keystonemiddleware to send CADF notification to ceilometer.
Then ceilometer can resend CADF notifications to external CADF collector.


Requirements
------------
Plugin currently compatible only with Mirantis OpenStack 7.0

Radosgw doesn't suppport CADF so we're using rgwift as radosgw proxy.
Plugin implies using ubuntu packages *rgwift* and *python-wsgiproxy* from local repository.
Script pre_build_hook tries to download them during the plugin building.


Limitations
-----------
CADF notifications for Rados works only with Ceph.
Swift isn't supported.


Additional info
-----------

You can use built package provided in this directory. Or you can built plugin yourself. Please make sure that you use modified version
of plugin builder wich allows post install script execution.

Where you can find modified plugin builder:

https://github.com/sheva-serg/fuel-plugins

Short instruction for plugin Builder

  - Install system packages fpb module relies on:
  - If you use Ubuntu, install packages `createrepo rpm dpkg-dev`
  - If you use CentOS, install packages `createrepo dpkg-devel dpkg-dev rpm rpm-build`

Install fpb using pip. It's a good idea to install it into a virtualenv env:

pip install -e 'git+https://github.com/sheva-serg/fuel-plugins.git#egg=fuel_plugin_builder&subdirectory=fuel_plugin_builder'



