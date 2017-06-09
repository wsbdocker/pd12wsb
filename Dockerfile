##############################################
### DOCKER IMAGE FOR UBUNTU AND LIMESURVEY ###
##############################################

# Base Image is Ubuntu
FROM ubuntu:14.04

# Author WSBTester2016/2017
MAINTAINER PD12

# Install Apache2 packages
RUN apt-get update && \
  apt-get install -y apache2 && \
  apt-get clean
  
# Install PHP5 and MySql
RUN apt-get install -y php5 libapache2-mod-php5 php5-gd php5-ldap php5-imap \
	php5-curl php5-pgsql php5-mysqlnd php5-sqlite php5-mcrypt sendmail php5-json tar && \
	apt-get clean && \
	php5enmod mcrypt imap

#ADD ./start.sh /start.sh
#ADD ./foregorund.sh /etc/apache2/foregroud.sh
#ADD ./supervisord.conf /etc/supervisord.conf

RUN echo %sudo ALL=NOPASSWD: ALL >> /etc/sudoers

RUN rm -rf /app
ADD limesurvey.tar.gz /
#RUN tar -xzf /limesurvey.tar.gz /
RUN mv limesurvey app; \
	mkdir -p /extractlimes; \
	chown -R www-data:www-data /app

RUN cp -r /app/limes/* /extractlimes ; \
	chown -R www-data:www-data /extractlimes
  
RUN chown www-data:www-data /var/lib/php5	

VOLUME /app/limes

# ENV APACHE_LOG_DIR /var/log/apache2
# ENV APACHE_LOG_DIR /app/limes
# Set the Apache public folder to /var/www/html using configuration file
ADD apachserver /etc/apache2/sites-available/000-default.conf
	
# Expose container to specific ports, HTTP:80, SSL:443. 
EXPOSE 80
EXPOSE 443
	
# Launch Apache2 Server in the foreground	
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]