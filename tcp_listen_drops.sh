# Customer requested for an investigation of long-running queries and TCP ListenDrops were noticed:
cat /proc/net/netstat | awk '(f==0) {name=$1; i=2; while ( i<=NF) {n[i] = $i; i++ }; f=1; next}
(f==1){ i=2; while ( i<=NF){ printf "%s%s = %d\n", name, n[i], $i; i++}; f=0} '|grep Listen

# TcpExt:ListenOverflows = 3525
# TcpExt:ListenDrops = 1563193
# TcpExt:TCPFastOpenListenOverflow = 0
