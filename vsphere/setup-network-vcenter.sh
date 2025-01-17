#!/bin/bash

esxcli network vswitch starndard add -v vSwitch1

esxcfg-vswitch -L vusb0 vSwitch1

esxcli network ip netstack add -N jStack01


esxcli network vswitch standard portgroup add -p "Control Plane Network" -v vSwitch1

esxcli network vswitch standard portgroup set -p "Control Plane Network" --vlan-id 1

esxcli network ip interface add -i vmk1 -p "Control Plane Network" -N "jStack01"

esxcli network ip interface ipv4 set -i vmk1 -I 192.168.0.2 -N 255.255.255.0 -t static -g 192.168.0.250

esxcli network vswitch standard uplink add -v vSwitch1 -u vusb0
