#run the image of the database
sudo docker run --name worldapi_db -e MYSQL_ROOT_PASSWORD=123456secret -e "MYSQL_DATABASE=homestead" -e "MYSQL_USER=homestead" -e "MYSQL_PASSWORD=secret" -d mysql:5.6 

# running docker logs worldapi_db the last 2 lines of the output is like this
# 2015-08-24 01:30:57 1 [Note] mysqld: ready for connections.
# Version: '5.6.26'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
# running docker ps the output is like this
# sudo docker ps
# CONTAINER ID        IMAGE               COMMAND                CREATED              STATUS              PORTS                     NAMES
# 358aa30e492a        mysql:5.6           "/entrypoint.sh mysq   About a minute ago   Up About a minute   0.0.0.0:32772->3306/tcp   worldapi_db   

# create the image
docker build -t worldapi:1.0 .
# Running this command there is a problem with php-apc package. If I run this command out of docker, it works ok. 
#E: Package 'php-apc' has no installation candidate
#INFO[0004] The command "/bin/sh -c apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl lynx-cur" returned a non-zero code: 100 

# run the image of the app
docker run --rm --name worldapi -h worldapi -e "APACHE_RUN_USER=www-data" -e "APACHE_RUN_GROUP=www-data" -e "APACHE_LOG_DIR=/var/log/apache2" -e "APACHE_LOCK_DIR=/var/lock/apache2" -e "APACHE_PID_FILE=/var/run/apache2.pid" -e "WORLD_API_DOCUMENT_ROOT=/opt/www/worldapi/public/" -e "WORLD_API_SERVER_NAME=api.world.com.ar" -e "DB_HOST=localhost" -e "DB_DATABASE=homestead" -e "DB_USERNAME=homestead" -e "DB_PASSWORD=secret" worldapi:1.0



