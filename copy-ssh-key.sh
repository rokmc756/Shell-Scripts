GW_HOST="192.168.0.101"
HOSTS_NETWORK="192.168.0"
# HOSTS_RANGE="61 65"
# HOSTS_RANGE="71 75"
HOSTS_RANGE="81 85"
# HOSTS_RANGE="91 95"

for ln in $(cat /Users/moonja/.ssh/known_hosts | grep -n 192.168.0.101 | cut -d : -f 1)
do
    echo $ln
    sed -ie "$ln"d /Users/moonja/.ssh/known_hosts
done

for i in `seq $HOSTS_RANGE`
do

    echo $i
    sshpass -p "changeme" ssh-copy-id -o StrictHostKeyChecking=no root@$HOSTS_NETWORK.$i

done
