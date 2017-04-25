#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
#PASSWORD='12345678'
#PROJECTFOLDER='symbiota'

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
