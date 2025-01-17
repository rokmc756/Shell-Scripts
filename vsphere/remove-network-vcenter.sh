#!/bin/bash

esxcli network vswitch standard uplink remove -v vSwitch1 -u vusb0

# esxcli network ip interface remove -i vmk1 -p "Control Plane Network" -N "jStack01"

esxcli network ip interface remove -i vmk1

esxcli network vswitch standard portgroup remove -p "Control Plane Network" -v vSwitch1

esxcli network ip netstack remove -N jStack01

esxcli network vswitch standard remove --vswitch-name=vSwitch1
