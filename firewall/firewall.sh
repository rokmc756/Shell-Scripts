#!/bin/sh
# firewall
# chkconfig: 3 21 91
# description: Starts, stops iptables firewall

case "$1" in
start)

# Clear rules
iptables -t filter -F
iptables -t filter -X
echo - Clear rules : [OK]

# SSH In
iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
echo - SSH : [OK]

# Don't break established connections
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
echo - established connections : [OK]

# Block all connections by default
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP
echo - Block all connections : [OK]

# SYN-Flood Protection
iptables -N syn-flood

# * add
iptables -A syn-flood -p tcp --syn -j syn-flood

iptables -A syn-flood -m limit --limit 10/second --limit-burst 50 -j RETURN
iptables -A syn-flood -j LOG --log-prefix "SYN FLOOD: "
iptables -A syn-flood -j DROP
echo - SYN-Flood Protection : [OK]


# limit
# This module matches at a limited rate using a token bucket filter. A rule using this extension will match until this limit is reached.
# It can be used in combination with the LOG target to give limited logging for example.

# xt_limit has no negation support - you will have to use -m hashlimit ! --hashlimit rate in this case whilst omitting --hashlimit-mode.

# --limit rate[/second|/minute|/hour|/day]
#    Maximum average matching rate: specified as a number, with an optional `/second', `/minute', `/hour', or `/day' suffix; the default is 3/hour.
# --limit-burst number
#    Maximum initial number of packets to match: this number gets recharged by one every time the limit specified above is not reached, up to this number; the default is 5. 
#

# Loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT
echo - Loopback : [OK]

# ICMP (Ping)
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT
echo - PING : [OK]

# DNS In/Out
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
echo - DNS : [OK]

# NTP Out
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
echo - NTP : [OK]

# WHOIS Out
iptables -t filter -A OUTPUT -p tcp --dport 43 -j ACCEPT
echo - WHOIS : [OK]

# FTP Out
iptables -t filter -A OUTPUT -p tcp --dport 20:21 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 30000:50000 -j ACCEPT
# FTP In
iptables -t filter -A INPUT -p tcp --dport 20:21 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 30000:50000 -j ACCEPT
iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
echo - FTP : [OK]

# HTTP + HTTPS Out
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
# HTTP + HTTPS In
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
echo - HTTP/HTTPS : [OK]

# Mail SMTP:25
iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
echo - SMTP : [OK]

# Mail POP3:110
iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT
echo - POP : [OK]

# Mail IMAP:143
iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
echo - IMAP : [OK]

# Kloxo
iptables -t filter -A INPUT -p tcp --dport 7777:7778 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 7777:7778 -j ACCEPT
echo - Kloxo : [OK]

echo - Firewall [OK]
exit 0
;;

stop)
echo "Stopping Firewall... "
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t filter -F
echo "Firewall Stopped!"
exit 0
;;

restart)
/etc/init.d/firewall stop
/etc/init.d/firewall start
;;

*)
echo "Usage: /etc/init.d/firewall {start|stop|restart}"
exit 1
;;
esac
