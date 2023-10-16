esxcli network ip interface remove -i vmk1
esxcli network vswitch standard portgroup remove -p "Control Plane Network" -v vSwitch0
esxcli network ip netstack remove -N jStack01
