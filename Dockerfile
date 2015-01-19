# sugarCRM

FROM ubuntu:12.04

# install depend packages
RUN apt-get update && \
    apt-get install -y \ 
	apache2 \
	php5 php5-cli \
	php5-gd php5-curl php5-imap php5-mysql \
	unzip \
	curl \
	wget \
	supervisor

# download SugarCRM
RUN wget "http://downloads.sourceforge.net/project/sugarcrm/1%20-%20SugarCRM%206.5.X/SugarCommunityEdition-6.5.X/SugarCE-6.5.17.zip" && \
	unzip ./SugarCE-6.5.17.zip && \
	mv ./SugarCE-Full-6.5.17 ./SugarCE && \
	chown -R www-data ./SugarCE && \
	chmod 664 ./SugarCE/config.php && \
	chmod 664 ./SugarCE/config_override.php && \
	chmod 775 ./SugarCE/custom && \
	chmod -R 775 ./SugarCE/cache && \
	chmod -R 775 ./SugarCE/modules && \
	chmod 775 ./SugarCE/upload && \
	chmod 777 ./SugarCE/sugarcrm.log && \
	mv ./SugarCE /var/www && \
	rm ./SugarCE-6.5.17.zip

# add volume
RUN mkdir -p /scripts/
VOLUME /temp

# copy config file and scripts
ADD conf/config_si.temp /scripts/
ADD scripts/start.sh /scripts/
ADD scripts/foreground.sh /scripts/
RUN chmod +x /scripts/*.sh

# configure supervisor
RUN \
	echo "[program:httpd]" >> /etc/supervisor/supervisord.conf && \
	echo "command=/scripts/foreground.sh" >> /etc/supervisor/supervisord.conf && \
	echo "stopsignal=6" >> /etc/supervisor/supervisord.conf

# define working directory
WORKDIR /scripts

# define default command
ENTRYPOINT ["/bin/bash"]
CMD ["/scripts/start.sh"]

# expose ports
EXPOSE 80

