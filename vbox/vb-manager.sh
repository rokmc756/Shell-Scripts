#!/bin/bash
#
# It provides features to start / stop and restart virtual machines on kvm environment
# and start / shutdown main services of virtual machines
#
# Initial date: 2021,08,20
# Author: Jack Moon, <rokmc756@gmail.com>
MASTER_HOST="rk8-master"
# MASTER_HOST="mdw6"
GW_HOST="192.168.0.2"
VMs="rk8-master rk8-slave rk8-node01 rk8-node02 rk8-node03"

function manage_vms() {

    for i in `echo $VMs`
    do
        VBoxMange $1 $i
    done

}

# Echo usage if something isn't right.
function usage() {
    echo "Usage: $0 [-c <start|reboot|shutdown|destroy>] [-g <shutdown|reboot>]" 1>&2; exit 1;
}

while getopts ":c:g:" arg; do
    case "${arg}" in
        c)
            VMS_CONTROL=${OPTARG}
            [[ "${VMS_CONTROL}" != "start" && "${VMS_CONTROL}" != "shutdown" && "${VMS_CONTROL}" != "reboot" && "${VMS_CONTROL}" != "destroy" ]] && usage
            ;;
        g)
            GW_CONTROL=${OPTARG}
            IS_GW_CONTROL="true"
            [[ "${GW_CONTROL}" != "shutdown" && "${GW_CONTROL}" != "reboot" ]] && usage
            ;;
        :)
            echo "ERROR: Option -$OPTARG requires an argument"
            usage
            ;;
        \?)
            echo "ERROR: Invalid option -$OPTARG"
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if [ -z "${VMS_CONTROL}" ]; then
    usage
fi

manage_vms $VMS_CONTROL

sleep 15

if [ "${IS_GW_CONTROL}" == "true" ]; then

    if [ -z "${VMS_CONTROL}" ] || [ -z "${GW_CONTROL}" ]; then
        usage
    fi

    if [ "${VMS_CONTROL}" == "shutdown" ]; then
        manage_gw $VMS_CONTROL $GW_CONTROL
    else
        echo "FATAL: gateway host should be controlled after virtual machines got shutdown"
    fi

fi

exit
