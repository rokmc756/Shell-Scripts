esxcli network vswitch standard add --vswitch-name=vSwitch1
esxcfg-vswitch -L vusb0 vSwitch1
esxcli network ip netstack add -N jStack01
esxcli network vswitch standard portgroup add -p "Internal VM Network" -v vSwitch1
esxcli network vswitch standard portgroup add -p "Control Plane Network" -v vSwitch1
esxcli network ip interface add -i vmk1 -p "Control Plane Network" -N "jStack01"
# From run this if aboves are already configured in esxi
esxcli network ip interface ipv4 set -i vmk1 -I 192.168.0.2 -N 255.255.255.0 -t static
# esxcli network ip interface ipv4 set -i vmk1 -I 192.168.219.101 -N 255.255.255.0 -t static -g 192.168.219.1
esxcli network vswitch standard uplink add -v vSwitch1 -u vusb0
