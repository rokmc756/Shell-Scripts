GW_HOST="192.168.0.101"

for ln in $(cat /Users/moonja/.ssh/known_hosts | grep -n 192.168.0.101 | cut -d : -f 1)
do
    echo $ln
    sed -ie "$ln"d /Users/moonja/.ssh/known_hosts
done

sshpass -p "Changeme12!@" ssh -o StrictHostKeyChecking=no root@192.168.0.101 "poweroff; halt"

