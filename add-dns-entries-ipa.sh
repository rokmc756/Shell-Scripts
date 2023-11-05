#!/bin/bash
#
# Add Reverse Zone
# ipa dnszone-add 0.168.192.in-addr.arpa.

# Add A and PTR record in IPA DNS Server listed in host-list file

filename='host-list'
n=1
while read line
do

  # Reading each line
  # echo "Line No. $n : $line"
  if [ -n "$line" ]; then
    HOST_NAME=`echo "$line" | awk '{print $1}'`
    IP_ADDR=`echo "$line" | awk '{print $2}'`
    LAST_IP_ADDR=`echo "$line" | awk '{print $2}' | cut -d . -f 4`

    REVERT_SUBNET=`echo "${IP_ADDR%.*}" | tr '.' '\n' | tac | xargs | sed -e 's/ /./g'`

    # Examples
    # echo $(tac -s '.' <<< ${IP_ADDR%.*})
    # echo "${IP_ADDR%.*}" | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1 }

    ipa dnsrecord-add jtest.pivotal.io. $HOST_NAME --a-rec $IP_ADDR
    ipa dnsrecord-add $REVERT_SUBNET.in-addr.arpa $LAST_IP_ADDR --ptr-rec $HOST_NAME.jtest.pivotal.io.

  fi

  n=$((n+1))

done < $filename

exit
