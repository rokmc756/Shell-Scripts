#!/bin/bash

SIGNO_KILL=9

# killsnoop from bcc-tools
PROG_KILLSNOOP=/usr/share/bcc/tools/killsnoop

# output format "TIME", "PID", "COMM", "SIG", "TPID", "RESULT"
# fields index counted from 0
i_TIME=0
i_PID=1
i_SIG=3
i_TPID=4

# column index counted from 1, for cut
c_PID=$((i_PID+1))
c_TPID=$((i_TPID+1))

lineno=0
$PROG_KILLSNOOP | while read -r line;
do
        fields=($line)
        if [ "${fields[$i_SIG]}" != "$SIGNO_KILL" ];then
                continue
        fi
        echo "Kill record $lineno :"
        echo $line
        #pid=`echo $line | cut -d " " -f $c_PID`
        pid=${fields[$i_PID]}
        echo "ps output of the killer process $pid":
        ps u -p $pid
        lineno=$((lineno+1))
done
