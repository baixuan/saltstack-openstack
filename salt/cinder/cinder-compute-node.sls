include:
  - init.compute

cinder-install:
  file.managed:
    - name: /usr/local/src/cinder.tar.gz
    - source: salt://cinder/files/cinder.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf cinder.tar.gz && cd cinder && pip install --no-index -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip -r tools/pip-requires && python setup.py install
    - require:
      - file: /usr/local/src/cinder.tar.gz
    - unless: test -d /usr/lib/python2.6/site-packages/cinder-2012.2.5-py2.6.egg

python-cinderclient:
  file.managed:
    - name: /usr/local/src/python-cinderclient.tar.gz
    - source: salt://cinder/files/python-cinderclient.tar.gz
    - mode: 644
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf python-cinderclient.tar.gz && cd python-cinderclient && pip install --no-index -f http://{{ pillar['kickstart']['SERVER_IP'] }}/pip -r tools/pip-requires && python setup.py install
    - require:
      - file: /usr/local/src/python-cinderclient.tar.gz
    - unless: test -d /usr/lib/python2.6/site-packages/python_cinderclient-1.0.4-py2.6.egg
