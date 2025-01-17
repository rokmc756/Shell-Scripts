HOSTNAME_PREFIX="co7-node0"

for i in $(seq 1 3)
do
    ssh root@$HOSTNAME_PREFIX$i 'systemctl stop zookeeper kafka'
    ssh root@$HOSTNAME_PREFIX$i 'systemctl status kafka zookeeper'
    ssh root@$HOSTNAME_PREFIX$i 'rm -rfv /tmp/lib/kafka/kafka-logs/data1/*'
    ssh root@$HOSTNAME_PREFIX$i 'rm -rfv /tmp/lib/kafka/kafka-logs/data2/*'
done

for i in $(seq 1 3)
do
    ssh root@$HOSTNAME_PREFIX$i 'systemctl start kafka zookeeper'
    ssh root@$HOSTNAME_PREFIX$i 'systemctl status kafka zookeeper'
done

ssh root@co7-master "systemctl restart kafka-ui"
ssh root@co7-master "systemctl status kafka-ui"


exit

for i in $(seq 1 3)
do
    ssh root@$HOSTNAME_PREFIX$i 'systemctl restart kafka zookeeper'
    ssh root@$HOSTNAME_PREFIX$i 'systemctl status kafka zookeeper'
done
