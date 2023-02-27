#!/bin/bash -x
exec > >(tee /var/log/userdata.log) 2>&1

# Install packages
sudo apt -y update
sudo apt -y upgrade
sudo apt install -y nginx
sudo apt install -y expect
sudo apt install -y mysql-server
sudo apt install -y mysql-client
sudo apt install -y php-fpm php-mysql
sudo apt install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

# Grant file ownership of /var/www & its contents to ubuntu user
sudo chown -R ubuntu /var/www/*
# Grant group ownership of /var/www & contents to ubuntu group
sudo chgrp -R ubuntu /var/www/*
# Change directory permissions of /var/www & its subdir to add group write 
sudo chmod 2775 /var/www/*
find /var/www -type d -exec sudo chmod 2775 {} \;
# Recursively change file permission of /var/www & subdir to add group write permmap_public_ip_on_launch = false
sudo find /var/www -type f -exec sudo chmod 0664 {} \;

sudo mysql --user=root <<EOF
  ALTER USER '${USERNAME}'@'${CONNECTION}' IDENTIFIED WITH mysql_native_password BY '${DB_ROOT_PASSWORD}';
  FLUSH PRIVILEGES;
EOF

expect << EOF
spawn sudo mysql_secure_installation
    expect "Enter password for user root: "
    send "${DB_ROOT_PASSWORD}\r"

    expect "VALIDATE PASSWORD COMPONENT can be used to test passwords
    and improve security. It checks the strength of password
    and allows the users to set only those passwords which are
    secure enough. Would you like to setup VALIDATE PASSWORD component? 
    Press y|Y for Yes, any other key for No: "
    send "y\r"

    expect "There are three levels of password validation policy: "
    send "2\r"

    expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) : "
    send "y\r"

    expect "New password: "
    send "${DB_PASSWORD}\r"

    expect "Re-enter new password: "
    send "${DB_PASSWORD}\r"

    expect "Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : "
    send "y\r"

    expect "Remove anonymous users? "
    send "y\r"

    expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) : "
    send "y\r"

    expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) : "
    send "y\r"

    expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) : "
    send "y\r"
EOF

# Wordpress Install
mkdir -p $HOME/wordpress
cd $HOME/wordpress
sudo curl -LO https://wordpress.org/latest.tar.gz && sudo tar -xzf latest.tar.gz

# Create wordpress database
mysql  -uroot -p"${DB_PASSWORD}" -e "CREATE USER '${DB_USERNAME}'@'localhost' IDENTIFIED BY '${WORDPRESSDB_PASSWORD}';"  2>/dev/null
mysql  -uroot -p"${DB_PASSWORD}" -e "GRANT ALL ON *.* TO '${DB_USERNAME}'@'localhost';FLUSH PRIVILEGES;"  2>/dev/null
mysql  -uroot -p"${DB_PASSWORD}" -e "CREATE DATABASE ${DB_NAME};"  2>/dev/null

sudo cp /wordpress/wordpress/wp-config-sample.php wordpress/wp-config.php
sed -i "s/database_name_here/${DB_NAME}/g" wordpress/wp-config.php
sed -i "s/username_here/${DB_USERNAME}/g" wordpress/wp-config.php
sed -i "s/password_here/${WORDPRESSDB_PASSWORD}/g" wordpress/wp-config.php