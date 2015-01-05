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

# copy config file and scripts
ADD conf/config_si.temp /home/ubuntu/
ADD scripts/start.sh /home/ubuntu/
ADD scripts/foreground.sh /home/ubuntu/
ADD scripts/silentInstall.sh /home/ubuntu/
ADD scripts/upgradeApache.sh /home/ubuntu/
ADD scripts/upgradeSugarCRM.sh /home/ubuntu/
RUN chmod +x /home/ubuntu/*.sh

# configure supervisor
RUN \
	echo "[program:httpd]" >> /etc/supervisor/supervisord.conf && \
	echo "command=/home/ubuntu/foreground.sh" >> /etc/supervisor/supervisord.conf && \
	echo "stopsignal=6" >> /etc/supervisor/supervisord.conf

# define working directory
WORKDIR /home/ubuntu

# define default command
ENTRYPOINT ["/bin/bash"]
CMD ["/home/ubuntu/start.sh"]

# expose ports
EXPOSE 80

