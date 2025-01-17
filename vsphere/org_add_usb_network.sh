# Note: This script will not be run when UEFI secure boot is enabled.
#
#esxcfg-vswitch -U vusb0 vSwitch1
#
#sleep 2
#
#esxcfg-vswitch -L vusb0 vSwitch1
#
#sleep 2
#
#/bin/vim-cmd internalsvc/refresh_network
#
#exit 0
#
#

esxcli network vswitch standard add --vswitch-name=vSwitch1
# The below should be run for activate nic

esxcfg-vswitch -L vusb0 vSwitch1
esxcli network ip netstack add -N jStack01
esxcli network vswitch standard portgroup add -p "Control Plane Network" -v vSwitch1
esxcli network ip interface add -i vmk1 -p "Control Plane Network" -N "jStack01"
# From run this if aboves are already configured in esxi
esxcli network ip interface ipv4 set -i vmk1 -I 192.168.0.2 -N 255.255.255.0 -t static -g 192.168.219.1
esxcli network ip interface ipv4 set -i vmk1 -I 192.168.0.2 -N 255.255.255.0 -t static
esxcli network vswitch standard uplink add -v vSwitch1 -u vusb0

#
# vmkping gives vmkernel stack not configured error!
# esxcfg-vmknic -a -i 192:168:0::/24 -n 255.255.255.0 "Control Plane Network"
# vmkping -S jStack01 192.168.0.2
# 64 bytes from 192.168.0.2: icmp_seq=0 ttl=64 time=0.020 ms
#
# vmkping -S jStack01 192.168.0.250
# 64 bytes from 192.168.0.250: icmp_seq=0 ttl=64 time=1.956 ms

# Add or delete route table
esxcli network ip route ipv4 add --gateway 192.168.219.1 --network 192.168.0.0/24
esxcli network ip route ipv4 remove --gateway 192.168.219.1 --network 192.168.0.0/24

# Remove
esxcli network ip interface remove -i vmk1
esxcli network vswitch standard portgroup remove -p "Control Plane Network" -v vSwitch1
esxcli network ip netstack remove -N jStack01
esxcli network vswitch standard remove --vswitch-name=vSwitch1



esxcli network vswitch standard portgroup set --vlan-id 0 -p "Control Plane Network"
esxcli network vswitch standard portgroup set --vlan-id 0 -p "Internal VM Network"
esxcli network vswitch standard portgroup set --vlan-id 0 -p "VM Network"
esxcli network vswitch standard portgroup set --vlan-id 0 -p "Management Network"
