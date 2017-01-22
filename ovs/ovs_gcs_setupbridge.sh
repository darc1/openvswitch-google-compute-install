#!/bin/bash

time sudo apt-get install python-eventlet python-routes python-webob python-paramiko python-oslo.config python-pip && pip install tinyrpc
git clone git://github.com/osrg/ryu.git

ovs-vsctl add-br vb0 
ifconfig vb0 up
MAC_OVS=$(cat /sys/class/net/vb0/address)
MAC=$(cat /sys/class/net/ens4/address)
echo $MAC_OVS $MAC
ovs-vsctl add-port vb0 ens4
ifconfig ens4 0
/etc/init.d/networking stop
ip link set ens4 address $MAC_OVS
ovs-vsctl set bridge vb0 other-config:hwaddr=$MAC
/etc/init.d/networking start &

dhclient vb0

ovs-vsctl set bridge vb0 protocols=OpenFlow14

time sudo apt-get install python-eventlet python-routes python-webob python-paramiko python-oslo.config python-pip && pip install tinyrpc
git clone git://github.com/osrg/ryu.git