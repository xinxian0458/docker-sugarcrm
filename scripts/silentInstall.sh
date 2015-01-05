#!/bin/bash

# download and unzip SugarCRM
wget "http://downloads.sourceforge.net/project/sugarcrm/1%20-%20SugarCRM%206.5.X/SugarCommunityEdition-6.5.X/SugarCE-6.5.17.zip"
unzip ./SugarCE-6.5.17.zip
mv ./SugarCE-Full-6.5.17 ./SugarCE

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
cp ./config_si.temp ./config_si.php
sed -i 's/IS_INIT_DB/'$IS_INIT_DB'/g' ./config_si.php
if [[ $IS_INIT_DB -eq 0 ]]
then
# remove 'dbUSRData'
sed -i '/dbUSRData*/d' ./config_si.php
fi

ipAdd=`ip -f inet addr|grep eth0|grep inet|awk '{print $2}'|cut -d "/" -f1`
sed -i 's/SITE_URL/'$ipAdd'/g' ./config_si.php

mv ./config_si.php ./SugarCE/
cp ./SugarCE/config_si.php ./SugarCE/install/

echo -e "<?php\n\$sugar_config['http_referer']['actions']=array( 'index', 'ListView', 'DetailView', 'EditView', 'oauth', 'authorize', 'Authenticate', 'Login', 'SupportPortal', 'SaveTimezone' )\n?>" > ./SugarCE/config_override.php

# deploy SugarCRM into Apache
chown -R www-data ./SugarCE
chmod 664 ./SugarCE/config.php
chmod 664 ./SugarCE/config_override.php
chmod 775 ./SugarCE/custom
chmod -R 775 ./SugarCE/cache
chmod -R 775 ./SugarCE/modules
chmod 775 ./SugarCE/upload
chmod 777 ./SugarCE/sugarcrm.log
mv ./SugarCE /var/www

# auto install SugarCRM in silent mode
curl -X POST http://localhost/SugarCE/install.php?goto=SilentInstall&cli=true 
