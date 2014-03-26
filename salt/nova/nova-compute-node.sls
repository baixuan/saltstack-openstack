include:
  - nova.nova_compute_install
  - nova.nova_config

polkit:
  file.managed:
    - name: /etc/polkit-1/localauthority/50-local.d/50-nova.pkla
    - source: salt://nova/files/50-nova.pkla
    - user: root
    - group: root
    - mode: 644

nova-sudo:
  file.managed:
    - name: /etc/sudoers.d/nova
    - source: salt://nova/files/nova-sudo
    - user: root
    - group: root
    - mode: 400

nova-logrotate:
  file.managed:
    - name: /etc/logrotate.d/openstack-nova
    - source: salt://nova/files/openstack-nova-logrotate
    - user: root
    - group: root
    - mode: 644

eventlet-bug:
  cmd.run:
    - name: sed -i 's/def wait(self, check_interval=0.01):/def wait(self, check_interval=0.01,timeout=None):/g' /usr/lib/python2.6/site-packages/eventlet/green/subprocess.py
    - onlyif: test -f /usr/lib/python2.6/site-packages/eventlet/green/subprocess.py

nova-api-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-api
    - source: salt://nova/files/openstack-nova-api
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-api
    - unless: chkconfig --list |grep openstack-nova-api
    - require:
      - file: nova-api-service
  service.running:
    - name: openstack-nova-api
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
      - file: /etc/nova/rootwrap.d/volume.filters
    - require:
      - cmd.run: nova-api-service
      - cmd.run: nova-install
      - cmd.run: python-novaclient
      - file: /var/log/nova
      - file: /local/var/lib/nova/instances

nova-cert-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-cert
    - source: salt://nova/files/openstack-nova-cert
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-cert
    - unless: chkconfig --list |grep openstack-nova-cert
    - require:
      - file: nova-cert-service
  service.running:
    - name: openstack-nova-cert
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
      - file: /etc/nova/rootwrap.d/volume.filters
    - require:
      - cmd.run: nova-cert-service
      - cmd.run: nova-install
      - cmd.run: python-novaclient
      - file: /var/log/nova
      - file: /local/var/lib/nova/instances

nova-cluster-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-cluster
    - source: salt://nova/files/openstack-nova-cluster
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-cluster
    - unless: chkconfig --list |grep openstack-nova-cluster
    - require:
      - file: nova-cluster-service
  service.running:
    - name: openstack-nova-cluster
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
      - file: /etc/nova/rootwrap.d/volume.filters
    - require:
      - cmd.run: nova-cluster-service
      - cmd.run: nova-install
      - cmd.run: python-novaclient
      - file: /var/log/nova
      - file: /local/var/lib/nova/instances

nova-compute-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-compute
    - source: salt://nova/files/openstack-nova-compute
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-compute
    - unless: chkconfig --list |grep openstack-nova-compute
    - require:
      - file: nova-compute-service
  service.running:
    - name: openstack-nova-compute
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
      - file: /etc/nova/rootwrap.d/volume.filters
    - require:
      - cmd.run: nova-compute-service
      - cmd.run: nova-install
      - cmd.run: python-novaclient
      - file: /var/log/nova
      - file: /local/var/lib/nova/instances

nova-consoleauth-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-consoleauth
    - source: salt://nova/files/openstack-nova-consoleauth
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-consoleauth
    - unless: chkconfig --list |grep openstack-nova-consoleauth
    - require:
      - file: nova-consoleauth-service
  service.running:
    - name: openstack-nova-consoleauth
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
      - file: /etc/nova/rootwrap.d/volume.filters
    - require:
      - cmd.run: nova-consoleauth-service
      - cmd.run: nova-install
      - cmd.run: python-novaclient
      - file: /var/log/nova
      - file: /local/var/lib/nova/instances

nova-flow-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-flow
    - source: salt://nova/files/openstack-nova-flow
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-flow
    - unless: chkconfig --list |grep openstack-nova-flow
    - require:
      - file: nova-flow-service
  service.running:
    - name: openstack-nova-flow
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
      - file: /etc/nova/rootwrap.d/volume.filters
    - require:
      - cmd.run: nova-flow-service
      - cmd.run: nova-install
      - cmd.run: python-novaclient
      - file: /var/log/nova
      - file: /local/var/lib/nova/instances

nova-network-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-network
    - source: salt://nova/files/openstack-nova-network
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-network
    - unless: chkconfig --list |grep openstack-nova-network
    - require:
      - file: nova-network-service
  service.running:
    - name: openstack-nova-network
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
      - file: /etc/nova/rootwrap.d/volume.filters
    - require:
      - cmd.run: nova-network-service
      - cmd.run: nova-install
      - cmd.run: python-novaclient
      - file: /var/log/nova
      - file: /local/var/lib/nova/instances

nova-novncproxy-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-novncproxy
    - source: salt://nova/files/openstack-nova-novncproxy
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-nova-novncproxy
    - unless: chkconfig --list |grep openstack-nova-novncproxy
    - require:
      - file: nova-novncproxy-service
  service.running:
    - name: openstack-nova-novncproxy
    - enable: True
    - watch:
      - file: /etc/nova/api-paste.ini
      - file: /etc/nova/policy.json
      - file: /etc/nova/rootwrap.conf
      - file: /etc/nova/nova.conf
      - file: /etc/nova/rootwrap.d/api-metadata.filters
      - file: /etc/nova/rootwrap.d/compute.filters
      - file: /etc/nova/rootwrap.d/network.filters
      - file: /etc/nova/rootwrap.d/volume.filters
    - require:
      - cmd.run: nova-novncproxy-service
      - cmd.run: nova-install
      - cmd.run: python-novaclient
      - file: /var/log/nova
      - file: /local/var/lib/nova/instances

iptables-novnc:
  cmd.run:
    - name: iptables -I INPUT 5 -p tcp --dport 6080 -j ACCEPT && sed -i '/^:OUTPUT/a -A INPUT -p tcp --dport 6080 -j ACCEPT' /etc/sysconfig/iptables-config
    - unless: iptables -L -n |grep 6080

