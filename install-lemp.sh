#!/bin/bash

if [ $USER == 'root' ]
then
    echo ""
    echo "********************************************"
    echo "* Run this as your user, NOT root or sudo! *"
    echo "********************************************"

else
    echo ""
    echo "************************************"
    echo "* Installing Nginx, PHP, and MySql *"
    echo "************************************"

    sudo apt install nginx php-fpm mysql-server php-mysql php-mbstring php-xml php-gd php-curl

    sudo systemctl start nginx
    sudo systemctl enable nginx

    sudo systemctl start mysql
    sudo systemctl enable mysql

    echo ""
    echo ""
    echo "***********************"
    echo "* Setting Permissions *"
    echo "***********************"

    sudo chgrp -R www-data /var/www/html
    sudo find /var/www/html -type d -exec chmod g+rx {} +
    sudo find /var/www/html -type f -exec chmod g+r {} +

    sudo chown -R $USER /var/www/html
    sudo find /var/www/html -type d -exec chmod u+rwx {} +
    sudo find /var/www/html -type f -exec chmod u+rw {} +

    sudo find /var/www/html -type d -exec chmod g+s {} +

    printf "<?php\n\techo phpinfo();\n?>" > /var/www/html/info.php

    sudo mysql -u root -e "update mysql.user set plugin = 'mysql_native_password' where User='root';";
    sudo mysql -u root -e "FLUSH PRIVILEGES;";

    echo ""
    echo ""
    echo "*********************************"
    echo "* Setting a root MySQL password *"
    echo "*********************************"

    mysql_secure_installation

    echo ""
    echo ""
    echo "****************************************************************"
    echo "*                    Install Complete!                         *"
    echo "****************************************************************"
    echo "*                                                              *"
    echo "* - Visit 'http://localhost/info.php' to confirm PHP is set up *"
    echo "* - Your document root is set to: '/var/www/html/'             *"
    echo "* - Your apache config is at: '/etc/nginx/'                    *"
    echo "* - Your php config is at: '/etc/php/7.x/'                     *"
    echo "* - Log into mysql with: 'mysql -u root -p'                    *"
    echo "*                                                              *"
    echo "* - Restart apache: 'sudo systemctl restart nginx'             *"
    echo "* - Restart mysql: 'sudo systemctl restart mysql'              *"
    echo "*                                                              *"
    echo "****************************************************************"
fi

# SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

# In /etc/php/7.4/fpm/php.ini set:
#   "session.gc_probability = 1"
#   "memory_limit = 512M"

# In /etc/php/7.4/fpm/pool.d/www.conf, set:
#   pm.start_servers = 8
#   pm.min_spare_servers  = 8
#   pm.max_spare_servers  = 16
#   pm.max_children = 100