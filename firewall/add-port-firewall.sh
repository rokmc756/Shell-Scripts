#!/bin/bash

# zone_name="calico-net"
# HOSTS="rk9-master rk9-node01 rk9-node02 rk9-node03"
# HOSTS="co7-node01 co7-node02 co7-node03"
HOSTS="co7-master co7-slave co7-node01 co7-node02 co7-node03"
zone_name="public"
for i in `echo $HOSTS`
do
    ssh root@$i "firewall-cmd --zone=public --add-port=9866/tcp"
    # ssh root@$i "firewall-cmd --zone=public --add-port=9866/udp"
    ssh root@$i "firewall-cmd --reload"
    # ssh root@$i "firewall-cmd --permanent --new-zone=${zone_name}"
    # ssh root@$i "firewall-cmd --permanent --zone=${zone_name} --set-target=ACCEPT"
    #ssh root@$i "firewall-cmd --permanent --zone=${zone_name} --add-interface=vxlan.calico"
    # Then I looped through the calico network interfaces
    # ssh root@$i "sh /root/add-calico-net-firewalld.sh"
done
