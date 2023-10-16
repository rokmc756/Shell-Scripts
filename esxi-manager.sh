#!/bin/bash
#

esxi_host_addr="192.168.0.101"
esxi_host_user="root"
esxi_host_pass="Changeme12!@"

# vim-cmd vmsvc/power.getstate <vmid>

esxi_connect_string="sshpass -p "$esxi_host_pass" ssh -o StrictHostKeyChecking=no $esxi_host_user@$esxi_host_addr"
search_vms_string="vim-cmd vmsvc/getallvms | grep $i"
awk_string="| awk '{print $1}'"

VMs="rk9-freeipa vcenter1"
for i in ${VMs}
do

    vm_id=`$esxi_connect_string "vim-cmd vmsvc/getallvms | grep $i" | awk '{print $1}'`
    # $esxi_connect_string "vim-cmd vmsvc/power.getstate $vm_id" | grep -E "Powered|Powering"
    power_act_status=`$esxi_connect_string "vim-cmd vmsvc/power.getstate $vm_id" | grep -E "Powered|Powering" | awk '{print $1}'`
    power_status=`$esxi_connect_string "vim-cmd vmsvc/power.getstate $vm_id" | grep -E "Powered|Powering" | awk '{print $2}'`

    if [ "$power_act_status" == "Powered" ] && [ "$power_status" == "off" ]; then
        $esxi_connect_string "vim-cmd vmsvc/power.on $vm_id"
    fi

    if [ "$power_act_status" == "Powered" ] && [ "$power_status" == "on" ]; then
        $esxi_connect_string "vim-cmd vmsvc/power.off $vm_id"
    fi

    # $esxi_connect_string "vim-cmd vmsvc/power.off $vm_id"
    # $esxi_connect_string "vim-cmd vmsvc/power.getstate $vm_id" | grep "Power"
    $esxi_connect_string "vim-cmd vmsvc/power.getstate $vm_id"
    # $esxi_connect_string "vim-cmd vmsvc/power.on $vm_id"

done

# Check the power state of the virtual machine with the command:

