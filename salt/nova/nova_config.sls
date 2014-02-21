nova:
  user.present:
    - fullname: OpenStack Nova Daemons
    #- password: 
    - shell: /sbin/nologin
    - home: /var/lib/nova

/etc/nova:
  file.directory:
    - user: nova
    - group: nova
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: nova

/var/log/nova:
  file.directory:
    - user: nova
    - group: nova
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: nova

/var/run/nova:
  file.directory:
    - user: nova
    - group: nova
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: nova

/local/var/lib/nova:
  file.directory:
    - user: nova
    - group: nova
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: nova

/var/lock/subsys/nova:
  file.directory:
    - user: nova
    - group: nova
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: nova


/var/lock/nova:
  file.directory:
    - user: nova
    - group: nova
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: nova

/local/var/lib/nova/instances:
  file.directory:
    - user: nova
    - group: nova
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: nova

/etc/nova/api-paste.ini:
  file.managed:
    - source: salt://nova/files/api-paste.ini
    - mode: 644
    - user: nova
    - group: nova
    - template: jinja
    - defaults:
      AUTH_KEYSTONE_HOST: {{ pillar['nova']['AUTH_KEYSTONE_HOST'] }}
      AUTH_KEYSTONE_PORT: {{ pillar['nova']['AUTH_KEYSTONE_PORT'] }}
      AUTH_KEYSTONE_PROTOCOL: {{ pillar['nova']['AUTH_KEYSTONE_PROTOCOL'] }}
      ADMIN_KEYSTONE_TENANT: {{ pillar['nova']['ADMIN_KEYSTONE_TENANT'] }}
      ADMIN_KEYSTONE_USER: {{ pillar['nova']['ADMIN_KEYSTONE_USER'] }}
      ADMIN_KEYSTONE_PASS: {{ pillar['nova']['ADMIN_KEYSTONE_PASS'] }}
    - require:
      - user: nova

/etc/nova/policy.json:
  file.managed:
    - source: salt://nova/files/policy.json
    - mode: 644
    - user: nova
    - group: nova

/etc/nova/rootwrap.conf:
  file.managed:
    - source: salt://nova/files/rootwrap.conf
    - mode: 644
    - user: nova
    - group: nova

/etc/nova/rootwrap.d/api-metadata.filters:
  file.managed:
    - source: salt://nova/files/rootwrap.d/api-metadata.filters
    - mode: 644
    - user: nova
    - group: nova

/etc/nova/rootwrap.d/compute.filters:
  file.managed:
    - source: salt://nova/files/rootwrap.d/compute.filters
    - mode: 644
    - user: nova
    - group: nova

/etc/nova/rootwrap.d/network.filters:
  file.managed:
    - source: salt://nova/files/rootwrap.d/network.filters
    - mode: 644
    - user: nova
    - group: nova

/etc/nova/rootwrap.d/volume.filters:
  file.managed:
    - source: salt://nova/files/rootwrap.d/volume.filters
    - mode: 644
    - user: nova
    - group: nova

/etc/nova/nova.conf:
  file.managed:
    - source: salt://nova/files/nova.conf
    - mode: 644
    - user: nova
    - group: nova
    - template: jinja
    - defaults:
      FIXED_RANGE: {{ pillar['nova']['FIXED_RANGE'] }}
      MYSQL_NOVA_USER: {{ pillar['nova']['MYSQL_NOVA_USER'] }}
      MYSQL_NOVA_PASS: {{ pillar['nova']['MYSQL_NOVA_PASS'] }}
      MYSQL_SERVER_IP: {{ pillar['nova']['MYSQL_SERVER_IP'] }}
      MYSQL_NOVA_DBNAME: {{ pillar['nova']['MYSQL_NOVA_DBNAME'] }}
      RABBIT_HOST: {{ pillar['nova']['RABBIT_HOST'] }}
      RABBIT_PASS: {{ pillar['nova']['RABBIT_PASS'] }}
      GLANCE_HOST: {{ pillar['nova']['GLANCE_HOST'] }}
      VM_BASE_DIR: {{ pillar['nova']['VM_BASE_DIR'] }}
      KEYSTONE_HOST: {{ pillar['nova']['KEYSTONE_HOST'] }}
    - require:
      - user: nova

