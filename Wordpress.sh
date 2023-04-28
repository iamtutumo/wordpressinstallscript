#!/bin/bash

# Update the package list and upgrade all installed packages
sudo apt-get update && sudo apt-get upgrade -y

# Install Apache, MySQL, and PHP
sudo apt-get install -y apache2 mysql-server php

# Install the required PHP extensions for WordPress
sudo apt-get install -y php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc

# Create a new MySQL user and database for WordPress
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE wordpress;
CREATE USER 'upsyd'@'localhost' IDENTIFIED BY 'goliath5320!';
GRANT ALL PRIVILEGES ON wordpress.* TO 'upsyd'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Download and extract the latest version of WordPress to the Apache root directory
cd /var/www/html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz

# Copy the WordPress sample configuration file to the main configuration file
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Modify the database connection settings in the wp-config.php file
sudo sed -i "s/database_name_here/wordpress/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/wordpressuser/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/password/g" /var/www/html/wordpress/wp-config.php

# Set the correct file permissions for WordPress
sudo chown -R www-data:www-data /var/www/html/wordpress/

# Restart Apache to apply the changes
sudo systemctl restart apache2
