#!/bin/bash
#
# 2011. 12.27.
# wrritten by jymoon@clunet.co.kr
#

get_device_info() {

    DEV_NAME=$1

    if [ "$2" == "jb7" ]; then
   	 XID=$(/usr/bin/sg_inq -p 0x83 $DEV_NAME | grep "\[0x" | sed -e "1 d" | sed -e "$ d")
    elif [ "$2" == "js2" ]; then
   	 XID=$(/usr/bin/sg_inq -p 0x83 $DEV_NAME | grep "\[0x" | sed -e "1 d")
    else
   	 echo "You have to choose either jb7 or js2!"
   	 exit
    fi

    XID=${XID/\[/}
    XID=${XID/%\]/}

    while read -a line; do

   	 if [ "${line[6]}" == "$DEV_NAME" ]; then
   		 DEV_SCSI_ID="${line[1]} ${line[2]} ${line[3]}  ${line[4]}"
   		 DEV_SG_NAME=${line[0]}
   		 DEV_SG_NUM=${line[0]##*sg}
   		 RESULT_FIND="true"

   	 fi

   	 if [ "$RESULT_FIND" == "true" ] && [ "${line[6]}" == "" ]; then
   		 TARGET_ENC_SG_NAME="${line[0]}"    
   		 TARGET_ENC_SCSI_ID="${line[1]} ${line[2]} ${line[3]}  ${line[4]}"
   		 TARGET_ENC_SG_NUM=${line[0]##*sg}
   		 break
   	 fi

    done < <( /usr/bin/sg_map -x )

    HOST_ID=${DEV_SCSI_ID:0:1}
    SAS_ADDR_NUM=$(/usr/bin/sg_ses -p 0xa $TARGET_ENC_SG_NAME | grep -n $XID | cut -d : -f -1)
    BAY_NUM_LINE=$(($SAS_ADDR_NUM - 6))
    BAY_NUM=$(/usr/bin/sg_ses -p 0xa $TARGET_ENC_SG_NAME | sed -n "$BAY_NUM_LINE p" | awk '{print $11}')

    TARGET_ENC_SCSI_ID_DIR=$(echo $TARGET_ENC_SCSI_ID | sed -e "s/ /\\:/g")
    DEV_SCSI_ID_DIR=$(echo $DEV_SCSI_ID | sed -e "s/ /\\:/g")

    if [ "$2" == "jb7" ]; then
   	 if [ "$BAY_NUM" -lt "10" ]; then
   		 BAY_NUM="0"$BAY_NUM
   	 fi
    fi

    SCSI_BASE_DIR="/sys/class/scsi_host/host$HOST_ID/device"

}

disk_blink() {

    # echo $1 $2
    get_device_info $1 $2

    if [ "$2" == "jb7" ]; then
      echo 1 > /sys/class/enclosure/$TARGET_ENC_SCSI_ID_DIR/DISK" "$BAY_NUM/fault
    elif [ "$2" == "js2" ]; then
      echo 1 > /sys/class/enclosure/$TARGET_ENC_SCSI_ID_DIR/$BAY_NUM/fault
    fi

}

disk_unblink() {

    get_device_info $1 $2

    # blink
    if [ "$2" == "jb7" ]; then
      echo 0 > /sys/class/enclosure/$TARGET_ENC_SCSI_ID_DIR/DISK" "$BAY_NUM/fault
    elif [ "$2" == "js2" ]; then
      echo 0 > /sys/class/enclosure/$TARGET_ENC_SCSI_ID_DIR/$BAY_NUM/fault
    fi

}

remove_disk() {

    # delete device
    get_device_info $1 $2
    cd $SCSI_BASE_DIR
    SCSI_ID_DIR=$(find ./ -name delete | grep $DEV_SCSI_ID_DIR)
    SCSI_ID_DIR=${SCSI_ID_DIR#.}

    # remove scsi from kernel
    # echo 1 >  $SCSI_BASE_DIR$SCSI_ID_DIR

}

add_disk() {

    # add new device
    get_device_info $1 $2
    cd $SCSI_BASE_DIR
    /sys/class/scsi_host/host$HOST_ID
    # echo "- - -" > scan
    echo "- - -"

}

mount() {

    # mount -L d006 "/srv/node/d006" or mount -a
    # mount -L $2 "/srv/node/$2" -o noatime,nodiratime,nobarrier,logbsize=256k,logbufs=8
    # chown swift.swift /srv/node/$2
    echo mount

}

unmount() {

    # unmount device
    # umount $DEV_NAME
    echo "umount $DEV_NAME"

}

format(){

    # format new device
    # dd if=/dev/zero bs=4k count=1 of=$DEV_NAME
    # mkfs.xfs -f -L "$VOLUME_NAME" -i size=1024 -l lazy-count=1 $DEV_NAME
    echo "format"

}

_help() {

    echo "help\n"

}

if [ $# -lt 6 ]; then
    echo -n "usage: `basename $0`"
    _help
    exit $OPTERROR
fi

while getopts "k:f:d:v:" options
do
    case $options in
   	 k)
   		 KIND=$OPTARG
   		 ;;
   	 f)
   		 FUNC=$OPTARG
   		 ;;
   	 d)
   		 DEVICE=$OPTARG
   		 ;;
   	 v)
   		 VNAME=$OPTARG
   		 ;;
   	 *)
   		 echo "usage: `basename $0` options (-ita)"
   		 exit $OPTERROR
   		 ;;
    esac
done

case "$FUNC" in
    "blink")
   	 disk_blink $DEVICE $KIND
   	 ;;
    "unblink")
   	 disk_unblink $DEVICE $KIND
   	 ;;
    "mount")
   	 mount $DEVICE $VNAME
   	 ;;
    "umount")
   	 umount $DEVICE $VNAME
   	 ;;
    "format")
   	 umount $DEVICE $VNAME
   	 ;;
    "add_disk")
   	 add_disk $DEVICE $KIND
   	 ;;
    "remove_disk")
   	 remove_disk $DEVICE $KIND
   	 ;;
    *)
   	 _help
   	 ;;
esac
