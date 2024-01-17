#!/bin/bash
#
# It provides features to start / stop and restart virtual machines on VMware environment
# and start / shutdown main services of virtual machines
#
# Initial date: 2021,08,20
# Author: Jack Moon, <rokmc756@gmail.com>
#
GW_HOST="192.168.0.101"
ESXI_PASSWD="Changeme12!@"

# sed -ie "$(cat ~/.ssh/known_hosts | grep -n 192.168.0.101 | cut -d : -f 1)d" ~/.ssh/known_hosts
# for ln in `cat /Users/moonja/.ssh/known_hosts | grep -n 192.168.0.101 | cut -d : -f 1`
#
for ln in $(cat /Users/moonja/.ssh/known_hosts | grep -n 192.168.0.101 | cut -d : -f 1)
do
    echo $ln
    sed -ie "$ln"d /Users/moonja/.ssh/known_hosts
done

# cat /Users/moonja/.ssh/known_hosts | grep 192.168.0.101

#
rh7_hosts="rh7-master rh7-slave rh7-node01 rh7-node02 rh7-node03"
co7_hosts="co7-master co7-slave co7-node01 co7-node02 co7-node03"
rk8_hosts="rk8-master rk8-slave rk8-node01 rk8-node02 rk8-node03"
rh8_hosts="rh8-master rh8-slave rh8-node01 rh8-node02 rh8-node03"
rk9_hosts="rk9-master rk9-slave rk9-node01 rk9-node02 rk9-node03"
ubt18_hosts="ubt18-master ubt18-slave ubt18-node01 ubt18-node02 ubt18-node03"
ubt22_hosts="ubt22-master ubt22-slave ubt22-node01 ubt22-node02 ubt22-node03"
harbor_hosts="rk9-harbor"
minio_hosts="rk9-minio"

#
function list_vms() {

    for i in `echo $VMs`
    do
       sshpass -p "$ESXI_PASSWD" ssh -o StrictHostKeyChecking=no root@$GW_HOST " "
    done

}

#
function manage_vms() {

    for i in `echo $VMs`
    do
       sshpass -p "$ESXI_PASSWD" ssh -o StrictHostKeyChecking=no root@$GW_HOST virsh $1 $i
    done

}

function manage_gw() {

    if [ "$1" == "shutdown" ]; then
       sshpass -p "$ESXI_PASSWD"  ssh -o StrictHostKeyChecking=no root@$GW_HOST "$1 -h now"
    else
        sshpass -p "$ESXI_PASSWD" ssh -o StrictHostKeyChecking=no root@$GW_HOST "$1"
    fi

}

# Echo usage if something isn't right.
function usage() {
    echo "Usage: $0 [-c <start|shutdown>] [-g <shutdown|reboot>] [-l <rh7|co7|rk8|rh8|rk9|minio|harbor>]" 1>&2; exit 1;
}

#
while getopts ":c:g:k:" arg; do
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
        k)
            OS_LIST=${OPTARG}
            INCLUDE_OS_LIST="true"
            [[ "${VMS_CONTROL}" != "start" && "${VMS_CONTROL}" != "shutdown" && "${VMS_CONTROL}" != "reboot" && "${VMS_CONTROL}" != "destroy" ]] && usage

            if  [ "${OS_LIST}" == "rh7" ]; then
                VMs=$rh7_hosts
            elif  [ "${OS_LIST}" == "co7" ]; then
                VMs=$co7_hosts
            elif  [ "${OS_LIST}" == "rh8" ]; then
                VMs=$rh8_hosts
            elif  [ "${OS_LIST}" == "rk8" ]; then
                VMs=$rk8_hosts
            elif  [ "${OS_LIST}" == "rk9" ]; then
                VMs=$rk9_hosts
            elif  [ "${OS_LIST}" == "ubt18" ]; then
                VMs=$ubt18_hosts
            elif  [ "${OS_LIST}" == "ubt22" ]; then
                VMs=$ubt22_hosts
            elif  [ "${OS_LIST}" == "minio" ]; then
                VMs=$minio_hosts
            elif  [ "${OS_LIST}" == "harbor" ]; then
                VMs=$harbor_hosts
            else
              usage
            fi
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

if [ -z "${VMS_CONTROL}" ] || [ -z "${OS_LIST}" ]; then
    usage
fi

manage_vms $VMS_CONTROL $OS_LIST

sleep 15

if [ "${IS_GW_CONTROL}" == "true" ]; then

    if [ -z "${VMS_CONTROL}" ] || [ -z "${GW_CONTROL}" ] || [ -z "${OS_LIST}" ]; then
        usage
    fi

    if [ "${VMS_CONTROL}" == "shutdown" ]; then
        manage_gw $VMS_CONTROL $GW_CONTROL
    else
        echo "FATAL: gateway host should be controlled after virtual machines got shutdown"
    fi

fi

exit
