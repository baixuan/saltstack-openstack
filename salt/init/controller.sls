controller-init:
  pkg.installed:
    - names:
      - gcc
      - gcc-c++
      - make
      - libtool
      - patch
      - automake
      - git
      - python-pip
      - wget

pip-install:
  file.managed:
    - name: /usr/local/src/pip-1.2.tar.gz
    - source: salt://init/files/pip-1.2.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src/ && tar zxf pip-1.2.tar.gz && cd pip-1.2 && python setup.py install && pip install setuptools_git --no-index -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip
    - unless: pip-python freeze | grep pip==1.2
    - unless: test -d /usr/lib/python2.6/site-packages/pip-1.2-py2.6.egg
    - require:
      - pkg: controller-init
      - file: /usr/local/src/pip-1.2.tar.gz

mysql-server:
  pkg.installed:
    - name:
      - mysql-server
  file.managed:
    - name: /etc/my.cnf
    - require:
      - pkg: mysql-server
  service.running:
    - name: mysqld
    - enable: True
    - require:
      - pkg: mysql-server
    - watch:
      - file: mysql-server
      - pkg: mysql-server
  cmd.run:
    - name: mysqladmin -uroot password '{{ pillar['kickstart']['MYSQL_PASS'] }}' && mysql -uroot -p{{ pillar['kickstart']['MYSQL_PASS'] }} -e "grant all on *.* to 'root'@'localhost' identified by '{{ pillar['kickstart']['MYSQL_PASS'] }}';" && mysql -uroot -p{{ pillar['kickstart']['MYSQL_PASS'] }} -e "grant all on *.* to 'root'@'%' identified by '{{ pillar['kickstart']['MYSQL_PASS'] tmq-server}}';" 

rabbitmq-server:
  pkg:
    - installed
  service.running:
    - name: rabbitmq-server
    - enable: True
    - require:
      - pkg: rabbitmq-server

libvirt-run:
  pkg.installed:
    - names:
      - libvirt
      - libvirt-python
  service.running:
    - name: libvirtd
    - enable: True
    - require:
      - pkg: libvirt-run

messagebus-run:
  service-running:
    - name: messagebus
    - enable: True
