include:
  - init.compute

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

python-amqplib:
  cmd.run:
    - name: cd /tmp && wget http://{{ pillar['kickstart']['SERVER_IP'] }}/python-amqplib-0.6.1-2.el6.noarch.rpm && rpm -ivh python-amqplib-0.6.1-2.el6.noarch.rpm
    - unless: rpm -qa |grep python-amqplib
