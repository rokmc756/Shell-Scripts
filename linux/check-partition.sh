# Find the 2 smallest drives in the system that are the same size, in case we should have mirrored boot drives (may be only one)
echo Starting boot drive selection process

# We need a temp file because just piping the first while loop into the second creates a subshell and the ARRAYs won't be set
TMPFILE=$(mktemp)
lsblk -b -d -o NAME,SIZE,ROTA,TYPE -n | sort -n --key=2 | grep disk | grep -v pmem | while read NAME SIZE ROTA TYPE; do
        GB_CAP=$[SIZE/1024/1024/1024]
        #echo $GB_CAP
        # we want only HDDs that are more than 111GB and less than 1.5TB in size
        if [ $GB_CAP -gt 120 ]; then
            echo ${NAME} ${GB_CAP}
        fi
done | head -2 > $TMPFILE

exit

NAME_ARRAY=()
SIZE_ARRAY=()
while read NAME SIZE; do
        echo $NAME $SIZE
        NAME_ARRAY+=($NAME)
        SIZE_ARRAY+=($SIZE)
done  < $TMPFILE
echo name array is ${NAME_ARRAY[@]}
echo size array is ${SIZE_ARRAY[@]}

# we're done with the temp file now
rm -f $TMPFILE

# sanity check
if [ ${#SIZE_ARRAY[@]} -eq 0 ]; then
        echo ERROR: no drives are in the system?
        echo Terminating
        exit 1
elif [ ${SIZE_ARRAY[0]} -lt 120 ]; then
        echo ERROR: This image requires a minimum of a 120GB boot drive
        echo Terminating
        exit 1
fi

if [ ${#SIZE_ARRAY[@]} -gt 1 ]; then
        echo There are two+ drives in the system
        if [ ${SIZE_ARRAY[0]} != ${SIZE_ARRAY[1]} ]; then
                # different size drives, so use the first (smaller) one
                echo different size drives, using smaller one
                BDEV1=${NAME_ARRAY[0]}
                BDEV2=""
        else
                echo boot drive mirroring enabled
                BDEV1=${NAME_ARRAY[0]}
                BDEV2=${NAME_ARRAY[1]}
        fi
else
        # only one boot drive
        echo only one boot drive
        BDEV1=${NAME_ARRAY[0]}
        BDEV2=""
fi

echo Boot devices are $BDEV1 and $BDEV2
echo
# need these as a comma-separated list for the partitioning commands below
BOOTDEVS=`echo $BDEV1 $BDEV2 | sed 's/ /,/g'`

# build the part-include file that gets used later in the %nclude directive
PART=/tmp/part-include

# wipe the drives, if any partitions exist
echo 'Wiping the boot drive(s)'
echo "ignoredisk --only-use=$BOOTDEVS" >> $PART
echo "clearpart --drives=$BOOTDEVS --all --initlabel --disklabel=gpt" >> $PART
echo "zerombr" >> $PART

/run/install/repo/partitioner.sh $(echo $BDEV1 $BDEV2) >> $PART
echo
echo Partitions set.  Partition commands are:
cat $PART

echo
echo "$(env TZ=Asia/Seoul date) Finished kickstart 1st pre section"
echo
