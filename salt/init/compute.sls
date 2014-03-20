compute-init:
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
      - pkg: compute-init
      - file: /usr/local/src/pip-1.2.tar.gz
