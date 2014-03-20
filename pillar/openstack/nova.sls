nova:
  AUTH_KEYSTONE_HOST: 10.0.0.178
  AUTH_KEYSTONE_PORT: 35357
  AUTH_KEYSTONE_PROTOCOL: http
  ADMIN_KEYSTONE_TENANT: service
  ADMIN_KEYSTONE_USER: nova
  ADMIN_KEYSTONE_PASS: service_pass
  FIXED_RANGE: 172.25.126.0/24
  MYSQL_NOVA_USER: novaUser
  MYSQL_NOVA_PASS: novaPass
  MYSQL_SERVER_IP: 10.0.0.178
  MYSQL_NOVA_DBNAME: nova
  RABBIT_HOST: 10.0.0.178
  RABBIT_PASS: root
  GLANCE_HOST: 10.0.0.178
  VM_BASE_DIR: /local/var/lib/nova/instances
  KEYSTONE_HOST: 10.0.0.178
