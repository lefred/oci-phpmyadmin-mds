#!/bin/bash
#set -x

yum install -y mysql-router-community-${mysql_version}  --refresh

echo "MySQL Router installed successfully!"

cat <<EOF >> /etc/mysqlrouter/mysqlrouter.conf
[routing:primary]
bind_address = 0.0.0.0
bind_port = 3306
destinations = ${mds_ip}:3306
routing_strategy = first-available

[routing:primary_x]
bind_address = 0.0.0.0
bind_port = 33060
destinations = ${mds_ip}:33060
routing_strategy = first-available
protocol = x

EOF


echo "MySQL Router configured successfully!"

firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --zone=public --add-port=33060/tcp --permanent
firewall-cmd --reload

echo "Local Firewall updated"

systemctl start mysqlrouter >/dev/null 2>&1
if [[ $? -eq 0 ]]
then
    echo "MySQL Router is running..."
fi
