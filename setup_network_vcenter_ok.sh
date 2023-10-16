esxcfg-vswitch -a vSwitch1
esxcfg-vswitch -A "Control Plane Network" vSwitch1
esxcfg-vswitch -L vusb0 vSwitch1
esxcli network ip netstack add -N jStack01
esxcli network ip interface add -i vmk1 -p "Control Plane Network" -N "jStack01"
esxcli network ip interface ipv4 set -i vmk1 -I 192.168.0.2 -N 255.255.255.0 -t static -g 192.168.0.250
esxcfg-vswitch -A "Control Plane VM Network" vSwitch1


esxcli network vswitch standard uplink add -v vSwitch1 -u vusb0
