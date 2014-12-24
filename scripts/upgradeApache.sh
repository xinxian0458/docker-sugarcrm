#!/bin/bash

echo "check apache version"
apacheversion=`apache2 -v`
echo "$apacheversion" | grep -q " Apache/2.4"
if [[ $? -eq 0 ]]; then
   echo "current apache version is 2.4, no need to upgrade it"
   exit 0
fi

echo "begin to upgrade apache2"
echo "1. backup "
if [[ ! -d /opt/apache2backup ]]
then
    mkdir /opt/apache2backup
fi
cp -r /etc/apache2 /opt/apache2backup/apache2
cp -a /var/www /opt/apache2backup/www

echo "2. remove old apache"
supervisorctl stop httpd
apt-get purge -y --auto-remove apache2*
apt-get purge -y --auto-remove php5 php5-gd php5-curl php5-imap php5-mysql

rm -rf /var/www/

echo "3. install apache2.4"
apt-get install -y python-software-properties
apt-add-repository -y ppa:ondrej/php5
apt-get update
apt-get install -y apache2
apt-get install -y php5 php5-gd php5-curl php5-imap php5-mysql

echo "4. deploy applications to /var/www/html"
cp -a /opt/apache2backup/www/* /var/www/html/
chgrp -R www-data /var/www/html/*

echo "5. restart apache2"

supervisorctl restart httpd
