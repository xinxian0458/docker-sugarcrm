#!/bin/bash

sudo apt-get install -y unzip

# download sugarcrm upgrade packages
wget -O  silentupgrade.zip http://sourceforge.net/projects/sugarcrm/files/1%20-%20SugarCRM%206.5.X/SugarCommunityEdition-6.5.X%20Upgrade/silentUpgrade-CE-6.5.18.zip
wget -O  sugarceupgrade.zip http://sourceforge.net/projects/sugarcrm/files/1%20-%20SugarCRM%206.5.X/SugarCommunityEdition-6.5.X%20Upgrade/SugarCE-Upgrade-6.5.x-to-6.5.18.zip
unzip silentupgrade.zip -d /home/ubuntu/upgrade/

# upgrade according to apache version
if [[ -d /var/www/html/SugarCE ]]; then
	chmod 777 /var/www/html/SugarCE/sugar_version.php
	php -f /home/ubuntu/upgrade/silentUpgrade.php /home/ubuntu/sugarceupgrade.zip /home/ubuntu/upgrade/upgrade.log /var/www/html/SugarCE/ admin
	chgrp -R www-data /var/www/html/*
else
	chmod 777 /var/www/SugarCE/sugar_version.php
	php -f /home/ubuntu/upgrade/silentUpgrade.php /home/ubuntu/sugarceupgrade.zip /home/ubuntu/upgrade/upgrade.log /var/www/SugarCE/ admin
	chgrp -R www-data /var/www/*
fi

