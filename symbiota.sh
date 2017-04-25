#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
PROJECTFOLDER='symbiota'

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

# Create Symbiota database
mysql -uroot -p12345678 -e "create database symbiota"

# Create users and assign permissions
# Read/write user 
mysql -uroot -p12345678 -e "CREATE USER 'symbiota-rw'@'localhost' IDENTIFIED BY 'symbiota-rw-pass'"
mysql -uroot -p12345678 -e "GRANT ALL PRIVILEGES ON symbiota.* TO 'symbiota-rw'@'localhost'"

# Read only user
mysql -uroot -p12345678 -e "CREATE USER 'symbiota-r'@'localhost' IDENTIFIED BY 'symbiota-r-pass'"
mysql -uroot -p12345678 -e "GRANT SELECT ON symbiota.* TO 'symbiota-r'@'localhost'"

# create schema
mysql -uroot -p12345678 symbiota < /var/www/html/symbiota/config/schema-1.0/utf8/db_schema-1.0.sql
mysql -uroot -p12345678 symbiota < /var/www/html/symbiota/config/schema-1.0/utf8/db_schema_patch-1.1.sql
