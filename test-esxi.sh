
for ln in $(cat /Users/moonja/.ssh/known_hosts | grep -n 192.168.0.101 | cut -d : -f 1)
do
    echo $ln
    sed -ie "$ln"d /Users/moonja/.ssh/known_hosts
done

esxi_host_addr="192.168.0.101"
esxi_host_user="root"
esxi_host_pass="Changeme12!@"

# vim-cmd vmsvc/power.getstate <vmid>

sshpass -p "$esxi_host_pass" ssh -o StrictHostKeyChecking=no $esxi_host_user@$esxi_host_addr "vim-cmd vmsvc/getallvms | awk '{print \$2}'"
