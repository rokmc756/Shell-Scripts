#!/bin/bash
#
# It provides features to start / stop and restart virtual machines on kvm environment
# and start / shutdown main services of virtual machines
#
# Initial date: 2021,08,20
# Author: Jack Moon, <rokmc756@gmail.com>

MASTER_HOST="mdw6"
# MASTER_HOST="mdw6"
GW_HOST="192.168.0.2560"
# VMs="mdw7 smdw7 sdw7-01 sdw7-02 sdw7-03"
# VMs="postgres-haproxy01 postgres-haproxy02 postgres-ha01 postgres-ha02 postgres-ha03 mdw6 smdw6 sdw6-01 sdw6-02 sdw6-03"
# VMs="postgres-haproxy01 postgres-haproxy02 postgres-ha01 postgres-ha02 postgres-ha03"
# VMs="mdw6 smdw6 sdw6-01 sdw6-02 sdw6-03"
# VMs="mdw5 smdw5 sdw5-01 sdw5-02 sdw5-03"
# VMs="mdw4 smdw4 sdw4-01 sdw4-02 sdw4-03"
# VMs="postgres-haproxy01 postgres-haproxy02 postgres-ha01 postgres-ha02 postgres-ha03"
VMs="co7-master co7-slave co7-node01 co7-node02 co7-node03"

function manage_vms() {

    for i in `echo $VMs`
    do
        VBoxManage $1 $i
    done

}

function manage_gw() {

    if [ "$1" == "shutdown" ]; then
        ssh root@$GW_HOST "$1 -h now"
    else
        ssh root@$GW_HOST "$1"
    fi

}

# Echo usage if something isn't right.
function usage() {
    echo "Usage: $0 [-c <startvm|poweroff>] [-g <shutdown|reboot>]" 1>&2; exit 1;
}

while getopts ":c:g:" arg; do
    case "${arg}" in
        c)
            VMS_CONTROL=${OPTARG}
            [[ "${VMS_CONTROL}" != "startvm" && "${VMS_CONTROL}" != "poweroff" && "${VMS_CONTROL}" != "reboot" ]] && usage
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
