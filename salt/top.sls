base:
  'minion1.cienet.com.cn':
    - keystone.keystone-controller-node
    - cinder.cinder-compute-node
    - nova.nova-compute-node

  'minion2.cienet.com.cn':
    - keystone.keystone-compute-node
    - cinder.cinder-compute-node
    - nova.nova-compute-node
