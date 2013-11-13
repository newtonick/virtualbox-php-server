#!/bin/sh

sudo apt-get install aptitude
sudo apt-get install wget
sudo apt-get install openssh-client openssh-server
sudo apt-get install build-essential nginx autoconf libmemcached-dev libxml2-dev libcurl4-openssl-dev pkg-config libjpeg-dev libpng-dev libicu-dev libmcrypt-dev libgearman-dev libgraphicsmagick1-dev

mkdir ~/src
cd ~/src
wget http://us3.php.net/distributions/php-5.5.5.tar.gz
tar -xzf php-5.5.5.tar.gz
cd php-5.5.5
./configure '--with-mysql' '--with-mysqli' '--with-pdo-mysql' '--enable-fpm' '--with-fpm-user=www-data' '--with-fpm-group=www-data' '--enable-mbstring' '--with-curl' '--with-openssl' '--enable-sockets' '--enable-soap' '--enable-bcmath' '--enable-pcntl' '--enable-zip' '--with-zlib' '--with-gd' '--enable-gd-native-ttf' '--with-jpeg-dir' '--with-png-dir' '--with-mcrypt' '--disable-posix-threads' '--enable-intl' '--enable-opcache' || exit
make || exit
sudo make install || exit
sudo pecl install memcached
sudo pecl install gearman-1.0.3
sudo pecl install oauth
sudo pecl install gmagick-beta

# configure php ini

sudo cat > /usr/local/lib/php.ini <<DELIM
extension=memcached.so
extension=gearman.so
extension=gmagick.so
extension=oauth.so

upload_max_filesize = 10M;
post_max_size = 10M;
date.timezone = 'UTC';
DELIM


# setup mysql server

sudo apt-get install mysql-server mysql-client

# configure mysql server