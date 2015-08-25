FROM ubuntu:14.04.2

MAINTAINER Soledad Alvarez <salvarez@devspark.com>

# update the system
RUN apt-get update && apt-get -y upgrade
# install required packages 
RUN apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl lynx-cur

# enable apache 
# and enable virtual host config
RUN a2enmod php5
RUN a2enmod rewrite

# set environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV WORLD_API_DOCUMENT_ROOT /opt/www/worldapi/public/
ENV WORLD_API_SERVER_NAME api.world.com.ar
ENV DB_HOST localhost
ENV DB_DATABASE homestead
ENV DB_USERNAME homestead
ENV DB_PASSWORD secret

# copy apache config file
COPY apache2.conf /etc/apache2/apache2.conf
# copy virtual host config
COPY worldapi.conf /etc/apache2/sites-available/worldapi.conf

RUN a2ensite worldapi.conf

# copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
# change permissions to the entrypoint 
RUN  chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# copy the application in /opt/www directory
RUN mkdir -p /opt/www/worldapi
COPY worldapi /opt/www/worldapi

EXPOSE 80

CMD ["/usr/sbin/apache2","-D","FOREGROUND"]
