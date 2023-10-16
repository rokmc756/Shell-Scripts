#!/bin/bash

for i in `echo rk9-master rk9-node01 rk9-node02 rk9-node03`
do

    ssh root@$i "systemctl start firewalld"

done
