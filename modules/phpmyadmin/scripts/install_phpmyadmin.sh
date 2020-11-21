#!/bin/bash
#set -x

cd /var/www/
wget https://files.phpmyadmin.net/phpMyAdmin/${phpMyAdmin_version}/phpMyAdmin-${phpMyAdmin_version}-all-languages.zip
unzip phpMyAdmin-${phpMyAdmin_version}-all-languages.zip
rm -rf html/ phpMyAdmin-${phpMyAdmin_version}-all-languages.zip
mv phpMyAdmin-${phpMyAdmin_version}-all-languages html
chown apache. -R html
cd html
cp config.sample.inc.php config.inc.php
sed -i 's/localhost/${mds_ip}/' /var/www/html/config.inc.php

systemctl start httpd
systemctl enable httpd


echo "PHPMyAdmin installed and Apache started !"
