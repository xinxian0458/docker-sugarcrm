#!/bin/bash
apt-get update
apt-get install -y unzip wget

# download sugarcrm upgrade packages
wget http://sourceforge.net/projects/sugarcrm/files/1%20-%20SugarCRM%206.5.X/SugarCommunityEdition-6.5.X%20Upgrade/silentUpgrade-CE-6.5.18.zip
wget http://sourceforge.net/projects/sugarcrm/files/1%20-%20SugarCRM%206.5.X/SugarCommunityEdition-6.5.X%20Upgrade/SugarCE-Upgrade-6.5.x-to-6.5.18.zip
unzip silentUpgrade-CE-6.5.18.zip -d /home/ubuntu/upgrade/

# upgrade according to apache version
if [[ -d /var/www/html/SugarCE ]]; then
	php -f /home/ubuntu/upgrade/silentUpgrade.php /home/ubuntu/SugarCE-Upgrade-6.5.x-to-6.5.18.zip /home/ubuntu/upgrade/upgrade.log /var/www/html/SugarCE/ admin
	chgrp -R www-data /var/www/html/*
else
	php -f /home/ubuntu/upgrade/silentUpgrade.php /home/ubuntu/SugarCE-Upgrade-6.5.x-to-6.5.18.zip /home/ubuntu/upgrade/upgrade.log /var/www/SugarCE/ admin
	chgrp -R www-data /var/www/*
fi

