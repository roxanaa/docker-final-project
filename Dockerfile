FROM ubuntu:14.04

MAINTAINER Soledad Alvarez <salvarez@devspark.com>

# copy apache config file
COPY apache2.conf /etc/apache2/apache2.conf
# copy virtual host config
COPY worldapi.conf /etc/apache2/sites-available/worldapi.conf
# copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

#WORKDIR /opt/www/worldapi

# update the system 
RUN apt-get update && apt-get -y upgrade
# install required packages 
RUN apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl lynx-cur

# enable apache 
# and enable virtual host config
RUN /usr/sbin/a2enmod php5
RUN /usr/sbin/a2enmod rewrite
RUN a2ensite /etc/apache2/sites-available/worldapi.conf

# change permissions to the entrypoint 
RUN  chmod +x /entrypoint.sh

# copy the application in /opt/www directory
RUN mkdir -p /opt/www/worldapi

COPY worldapi /opt/www/worldapi

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND
