
#GW_HOST="192.168.0.101"
#for ln in $(cat /Users/moonja/.ssh/known_hosts | grep -n 192.168.0.101 | cut -d : -f 1)
#do
#    echo $ln
#    sed -ie "$ln"d /Users/moonja/.ssh/known_hosts
#done

# sshpass -p "Changeme12!@" ssh -o StrictHostKeyChecking=no root@192.168.0.101 "for VID in `vim-cmd vmsvc/getallvms | awk '{print $1}'`; do echo ${VID} `vim-cmd vmsvc/device.getdevices ${VID} | grep macAddress` ; done"

for h in `echo "weka4-temp weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05"`
do
	for VID in $(vim-cmd vmsvc/getallvms | grep $h | awk '{print $1}') ; do echo "$VID : $h" ; vim-cmd vmsvc/device.getdevices $VID | grep macAddress; done
done

