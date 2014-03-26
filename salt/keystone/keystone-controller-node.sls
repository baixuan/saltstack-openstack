include:
  - init.controller

keystone-init:
  pkg.installed:
    - names:
      - python-devel
      - libxslt-devel
      - openssl-devel
      - MySQL-python

keystone-install:
  file.managed:
    - name: /usr/local/src/keystone.tar.gz
    - source: salt://keystone/files/keystone.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf keystone.tar.gz && cd keystone && pip install --no-index -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip -r tools/pip-requires && python setup.py install
    - require:
      - pkg: keystone-init
      - file: /usr/local/src/keystone.tar.gz
    - unless: test -d /usr/lib/python2.6/site-packages/keystone-2012.2.2-py2.6.egg

python-keystoneclient:
  file.managed:
    - name: /usr/local/src/python_keystoneclient.tar.gz
    - source: salt://keystone/files/python_keystoneclient.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf python_keystoneclient.tar.gz && cd python_keystoneclient && pip install --no-index -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip -r tools/pip-requires && pip install hgtools -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip && pip install --no-index pytest-runner -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip && pip install --no-index keyring -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip && python setup.py install
    - require:
      - pkg: keystone-init
      - file: /usr/local/src/python_keystoneclient.tar.gz
    - unless: test -d /usr/lib/python2.6/site-packages/python_keystoneclient-0.1.3.31-py2.6.egg

keystone:
  user.present:
    - fullname: OpenStack Keystone Daemons
    #- password:
    - shell: /sbin/nologin
    - home: /var/lib/keystone

keystone-mysql:
  mysql_database.present:
    - name: {{ pillar['keystone']['KEYSTONE_DBNAME'] }}
    - require:
      - service: mysql-server
  mysql_user.present:
    - name: {{ pillar['keystone']['KEYSTONE_USER'] }}
    - host: {{ pillar['keystone']['HOST_ALLOW'] }}
    - password: {{ pillar['keystone']['KEYSTONE_PASS'] }}
    - require:
      - mysql_database: keystone-mysql
  mysql_grants.present:
    - grant: all
    - database: {{ pillar['keystone']['DB_ALLOW'] }}
    - user: {{ pillar['keystone']['KEYSTONE_USER'] }}
    - host: {{ pillar['keystone']['HOST_ALLOW'] }}
    - require:
      - mysql_user: keystone-mysql

/etc/keystone:
  file.directory:
    - user: keystone
    - group: keystone
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: keystone

/var/log/keystone:
  file.directory:
    - user: keystone
    - group: keystone
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: keystone

/var/lib/keystone:
  file.directory:
    - user: keystone
    - group: keystone
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: keystone

/var/run/keystone:
  file.directory:
    - user: keystone
    - group: keystone
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: keystone

/etc/keystone/default_catalog:
  file.managed:
    - source: salt://keystone/files/default_catalog
    - mode: 644
    - user: keystone
    - group: keystone
    - require:
      - user: keystone

/etc/keystone/logging.conf:
  file.managed:
    - source: salt://keystone/files/logging.conf
    - mode: 644
    - user: keystone
    - group: keystone
    - require:
      - user: keystone

/etc/keystone/policy.json:
  file.managed:
    - source: salt://keystone/files/policy.json
    - mode: 644
    - user: keystone
    - group: keystone
    - require:
      - user: keystone

/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://keystone/files/keystone.conf
    - mode: 644
    - user: keystone
    - group: keystone
    - require:
      - user: keystone
    - template: jinja
    - defaults:
      ADMIN_TOKEN: {{ pillar['keystone']['ADMIN_TOKEN'] }}
      KEYSTONE_USER: {{ pillar['keystone']['KEYSTONE_USER'] }}
      KEYSTONE_PASS: {{ pillar['keystone']['KEYSTONE_PASS'] }}
      MYSQL_SERVER: {{ pillar['keystone']['MYSQL_SERVER'] }}
      KEYSTONE_DBNAME: {{ pillar['keystone']['KEYSTONE_DBNAME'] }}

keystone-logrotate:
  file.managed:
    - name: /etc/logrotate.d/openstack-keystone
    - source: salt://keystone/files/openstack-keystone-logrotate
    - user: root
    - group: root
    - mode: 644

keystone-db-init:
  cmd.run:
    - name: keystone-manage db_sync && touch /var/run/keystone-dbsync.lock
    - require:
      - mysql_grants: keystone-mysql
    - unless: test -f /var/run/keystone-dbsync.lock

keystone-service:
  file.managed:
    - name: /etc/init.d/openstack-keystone
    - source: salt://keystone/file/openstack-keystone
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add openstack-keystone
    - unless: chkconfig --list |grep openstack-keystone
    - require:
      - file: keystone-service
  service.running:
    - name: openstack-keystone
    - enable: True
    - watch:
      - file: /etc/keystone/logging.conf
      - file: /etc/keystone/default_catalog
      - file: /etc/keystone/policy.json
      - file: /etc/keystone/keystone.conf
    - require:
      - cmd.run: keystone-install
      - cmd.run: keystone-db-init
      - cmd.run: keystone-service
      - file: /var/log/keystone

keystone_basic.sh:
  file.managed:
    - name: /tmp/keystone_basic.sh
    - source: salt://keystone/files/keystone_basic.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      CONTROL_IP: {{ pillar['keystone']['CONTROL_IP'] }}
      ADMIN_PASSWORD: {{ pillar['keystone']['ADMIN_PASSWORD'] }}
      SERVICE_PASSWORD: {{ pillar['keystone']['SERVICE_PASSWORD'] }}
      ADMIN_TOKEN: {{ pillar['keystone']['ADMIN_TOKEN'] }}
      SERVICE_TENANT_NAME: {{ pillar['keystone']['SERVICE_TENANT_NAME'] }}
  cmd.run:
    - name: sh /tmp/keystone_basic.sh && touch /var/run/keystone-datainit.lock
    - require:
      - file: keystone_basic.sh
      - service: openstack-keystone
    - unless: test -f /var/run/keystone-datainit.lock

keystone_endpoints_basic.sh:
  file.managed:
    - name: /tmp/keystone_endpoints_basic.sh
    - source: salt://keystone/files/keystone_endpoints_basic.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      CONTROL_IP: {{ pillar['keystone']['CONTROL_IP'] }}
      KEYSTONE_USER: {{ pillar['keystone']['KEYSTONE_USER'] }}
      KEYSTONE_DBNAME: {{ pillar['keystone']['KEYSTONE_DBNAME'] }}
      MYSQL_SERVER: {{ pillar['keystone']['MYSQL_SERVER'] }}
      KEYSTONE_PASS: {{ pillar['keystone']['KEYSTONE_PASS'] }}
      KEYSTONE_REGION: {{ pillar['keystone']['KEYSTONE_REGION'] }}
      ADMIN_TOKEN: {{ pillar['keystone']['ADMIN_TOKEN'] }}
  cmd.run:
    - name: sh /tmp/keystone_endpoints_basic.sh && /var/run/keystone-endpointinit.lock
    - require:
      - file: keystone_endpoints_basic.sh
      - service: openstack-keystone
      - cmd.run: keystone_basic.sh
    - unless: test -f /var/run/keystone-endpointinit.lock

/root/adminrc:
  file.managed:
    - source: salt://keystone/files/adminrc
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      ADMIN_PASSWORD: {{ pillar['keystone']['ADMIN_PASSWORD'] }}
      CONTROL_IP: {{ pillar['keystone']['CONTROL_IP'] }}
      ADMIN_TOKEN: {{ pillar['keystone']['ADMIN_TOKEN'] }}
