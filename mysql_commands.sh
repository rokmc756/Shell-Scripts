
mysql -h 192.168.219.250 -u pdns -p powerdns

create database powerdns
create user 'pdns'@'%' identified by 'Mc002661!@#$';
grant all privileges *.* to 'pdns'@'%';

# vi /usr/local/etc/my.cnf
#
bind-address=0.0.0.0

mysql.server stop
mysql.server start
