include:
  - init.compute

nova-init:
  pkg.installed:
    - names:
      - dbus
      - libvirt
      - libvirt-python
      - qemu-kvm
      - qemu-img
      - bridge-utils
      - dnsmasq
      - polkit
      - tunctl
      - python-numdisplay

libvirt-run:
  service.running:
    - name: libvirtd
    - enable: True
    - require:
      - pkg: nova-init

nova-install:
  file.managed:
    - name: /usr/local/src/nova.tar.gz
    - source: salt://nova/files/nova.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf nova.tar.gz && cd nova && pip install --no-index -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip -r tools/pip-requires && python setup.py install
    - require:
      - pkg: nova-init
      - file: /usr/local/src/nova.tar.gz
    - unless: test -d /usr/lib/python2.6/site-packages/nova-2012.2.1-py2.6.egg

python-novaclient:
  file.managed:
    - name: /usr/local/src/python_novaclient.tar.gz
    - source: salt://nova/files/python_novaclient.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf python_novaclient.tar.gz && cd python_novaclient && pip install --no-index -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip -r tools/pip-requires && python setup.py install
    - require:
      - pkg: nova-init
      - file: /usr/local/src/python_novaclient.tar.gz
    - unless: test -d /usr/lib/python2.6/site-packages/python_novaclient-2.9.0.30-py2.6.egg

websockify-install:
  file.managed:
    - name: /usr/local/src/websockify.tar.gz
    - source: salt://nova/files/websockify.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf websockify.tar.gz && cd websockify && python setup.py install
    - require:
      - pkg: nova-init
      - file: /usr/local/src/websockify.tar.gz
    - unless: test -d usr/lib/python2.6/site-packages/websockify-0.5.0_pre-py2.6.egg

novnc-install:
  file.managed:
    - name: /usr/local/src/noVNC.tar.gz
    - source: salt://nova/files/noVNC.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf noVNC.tar.gz && cp -rp noVNC /usr/share/novnc

