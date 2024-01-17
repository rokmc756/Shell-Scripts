esxcli network ip interface remove -i vmk1
esxcli network vswitch standard portgroup remove -p "Internal VM Network" -v vSwitch1
esxcli network vswitch standard portgroup remove -p "Control Plane Network" -v vSwitch1
esxcli network ip netstack remove -N jStack01
esxcli network vswitch standard remove --vswitch-name=vSwitch1
