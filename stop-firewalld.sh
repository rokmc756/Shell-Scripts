#!/bin/bash

# HOSTS="rk9-master rk9-slave rk9-node01 rk9-node02 rk9-node03"
HOSTS="co7-master co7-slave co7-node01 co7-node02 co7-node03"
for i in `echo $HOSTS`
do

    ssh root@$i "systemctl stop firewalld"

done
