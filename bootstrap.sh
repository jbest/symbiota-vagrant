#!/usr/bin/env bash

# Copied extensively from https://github.com/panique/vagrant-lamp-bootstrap

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
PROJECTFOLDER='symbiota'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# update / upgrade
sudo apt-get update
#sudo apt-get -y upgrade
# Using fix from https://github.com/chef/bento/issues/661#issuecomment-248136601
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install Composer
# curl -s https://getcomposer.org/installer | php
# mv composer.phar /usr/local/bin/composer

# install Symbiota files
sudo git clone https://github.com/Symbiota/Symbiota.git "/var/www/html/${PROJECTFOLDER}"
# retrieve pre-configured config files
curl -s https://raw.githubusercontent.com/jbest/symbiota-vagrant/master/config/dbconnection.php > "/var/www/html/${PROJECTFOLDER}/config/dbconnection.php"
curl -s https://raw.githubusercontent.com/jbest/symbiota-vagrant/master/config/symbini.php > "/var/www/html/${PROJECTFOLDER}/config/symbini.php"

# copy and rename interface template files
# Perhaps try running /config/setup.sh instead?
sudo cp /var/www/html/${PROJECTFOLDER}/index_template.php /var/www/html/${PROJECTFOLDER}/index.php
sudo cp /var/www/html/${PROJECTFOLDER}/leftmenu_template.php /var/www/html/${PROJECTFOLDER}/leftmenu.php
sudo cp /var/www/html/${PROJECTFOLDER}/header_template.php /var/www/html/${PROJECTFOLDER}/header.php
sudo cp /var/www/html/${PROJECTFOLDER}/footer_template.php /var/www/html/${PROJECTFOLDER}/footer.php
sudo cp /var/www/html/${PROJECTFOLDER}/robots_template.txt /var/www/html/${PROJECTFOLDER}/robots.txt
sudo cp /var/www/html/${PROJECTFOLDER}/css/main_template.css /var/www/html/${PROJECTFOLDER}/css/main.css
sudo cp /var/www/html/${PROJECTFOLDER}/css/speciesprofile_template.css /var/www/html/${PROJECTFOLDER}/css/speciesprofile.css
sudo cp /var/www/html/${PROJECTFOLDER}/css/jquery-ui_template.css /var/www/html/${PROJECTFOLDER}/css/jquery-ui.css
