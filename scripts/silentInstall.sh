#!/bin/bash

# init DB
if [[ $# -eq 1 && "$1" == "--init-db" ]]
then
# change config_si.php, enable create db and user
	IS_INIT_DB=1
else
# do nothing
	IS_INIT_DB=0
fi

# add silent install script into SugarCRM
cp /scripts/config_si.temp ./config_si.php
sed -i 's/IS_INIT_DB/'$IS_INIT_DB'/g' ./config_si.php
if [[ $IS_INIT_DB -eq 0 ]]
then
# remove 'dbUSRData'
sed -i '/dbUSRData*/d' ./config_si.php
fi

ipAdd=`ip -f inet addr|grep eth0|grep inet|awk '{print $2}'|cut -d "/" -f1`
sed -i 's/SITE_URL/'$ipAdd'/g' ./config_si.php

mv ./config_si.php /var/www/SugarCE/
cp /var/www/SugarCE/config_si.php /var/www/SugarCE/install/

# call silent install
curl -X POST http://localhost/SugarCE/install.php?goto=SilentInstall&cli=true
