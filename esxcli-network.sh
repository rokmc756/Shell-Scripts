esxcli network vswitch starndard add -v vSwitch1

# The below should be run for activate nic
esxcfg-vswitch -L vusb0 vSwitch1
esxcli network ip netstack add -N jStack01
esxcli network vswitch standard portgroup add -p "Control Plane Network" -v vSwitch1
esxcli network ip interface add -i vmk1 -p "Control Plane Network" -N "jStack01"

#
esxcli network vswitch standard portgroup add -p "Internal VM Network" -v vSwitch1



# From run this if aboves are already configured in esxi
# esxcli network ip interface ipv4 set -i vmk1 -I 192.168.0.101 -N 255.255.255.0 -t static -g 192.168.0.1
esxcli network ip interface ipv4 set -i vmk1 -I 192.168.219.101 -N 255.255.255.0 -t static -g 192.168.219.1
esxcli network vswitch standard uplink add -v vSwitch1 -u vusb0


#
# Unlike ESX, ESXi does not have a service console.
# The management network is on a vmkernel port and therefore, uses the default vmkernel gateway.
# Only one vmkernel default gateway can be configured on an ESXi/ESX host.
# However, you can add static routes to additional gateways/routers from the command line.
# https://kb.vmware.com/s/article/2001426
# esxcfg-route -a 192.168.219.0 255.255.255.0 192.168.0.1
# [root@esxi7:~] esxcfg-route -a 192.168.219.0 255.255.255.0 192.168.0.1
# Error: Invalid netmask, must be 32 > x > 0

sxcfg-route -a 192.168.219.0/24 192.168.0.1
# Adding static route 192.168.219.0/24 to VMkernel
