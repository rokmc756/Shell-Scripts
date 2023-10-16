#!/bin/bash


# Control Plain
for i in `echo rk9-master`
do

    ssh root@$i "firewall-cmd --zone=public --add-masquerade --permanent"
    ssh root@$i "systemctl restart firewalld"

done

for i in `echo rk9-node01 rk9-node02 rk9-node03`
do
    ssh root@$i "firewall-cmd --zone=public --add-masquerade --permanent"
    ssh root@$i "systemctl restart firewalld"
done
