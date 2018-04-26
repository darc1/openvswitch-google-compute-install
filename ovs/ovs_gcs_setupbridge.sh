#!/bin/bash
# Install ovs on Ubuntu vm in Google Cloud Platform
# On Ubuntu machines default interface is ens4

# Create bridge vb0
ovs-vsctl add-br vb0 
ifconfig vb0 up

# Store MAC of bridge
MAC_OVS=$(cat /sys/class/net/vb0/address)

# Store MAC of default interface
MAC=$(cat /sys/class/net/ens4/address)
echo $MAC_OVS $MAC
ovs-vsctl add-port vb0 ens4
ifconfig ens4 0
/etc/init.d/networking stop

#need to spoof the default interface MAC and assign it to the bridge
ip link set ens4 address $MAC_OVS
ovs-vsctl set bridge vb0 other-config:hwaddr=$MAC

/etc/init.d/networking start &

#request dhcp for bridge
dhclient vb0

ovs-vsctl set bridge vb0 protocols=OpenFlow14
