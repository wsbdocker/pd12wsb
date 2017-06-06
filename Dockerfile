# Install Ubuntu 14.04 and next set up PHP/MySql environment with additional
# packages and updates. At the end clean memory to regain diskspace
FROM nimmis/apache:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get -y install php5 libapache2-mod-php5 php5-gd php5-ldap php5-imap \
  php5-curl php5-pgsql php5-mysqlnd php5-sqlite php5-mcrypt sendmail php5-json && \
	apt-get clean && \
	php5enmod mcrypt imap
# Add PHP Composer
  cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Add Limesurvey and Install
RUN rm -rf /app
ADD limesurvey2651.tar.bz2 /
RUN mv wsbdocker app; \
	mkdir -p /uploadlimes; \
	chown -R www-data:www-data /app
  
RUN cp -r /app/upload/* /uploadlimes ; \
	chown -R www-data:www-data /uploadlimes
  
RUN chown www-data:www-data /var/lib/php5

# Set the Apache public folder to /var/www/html using configuration file
ADD apachserver /etc/apache2/sites-available/000-default.conf

# Expose container to specific ports, HTTP:80, SSL 443. 
EXPOSE 80
EXPOSE 443

# Run Apach Server
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
