#!/bin/bash -ex
# Adding swap temporarily in case of using t3.nano
dd if=/dev/zero of=/var/cache/swapfile bs=1M count=1024;
chmod 600 /var/cache/swapfile;
mkswap /var/cache/swapfile;
swapon /var/cache/swapfile;
free -m > /var/tmp/swap.txt
yum update -y;
yum upgrade -y;
amazon-linux-extras install epel -y;
yum upgrade -y;
yum install -y mariadb-server;
sed -i 's/^#Port 22/Port 2020/g' /etc/ssh/sshd_config;
systemctl restart sshd;
hostnamectl set-hostname ${host_name};
timedatectl set-timezone Europe/London;
systemctl enable mariadb --now;
amazon-linux-extras install php8.0
amazon-linux-extras enable php8.0;
yum clean metadata;
yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,devel,fpm}
yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl;
yum -y install php-pecl-imagick;
#chmod 755 /usr/lib64/php/modules/imagick.so;
#echo "extension=imagick" >>/etc/php.d/20-imagick.ini
systemctl restart php-fpm.service;

# Change OWNER and permission of directory /var/www
usermod -a -G apache ec2-user;
chown -R ec2-user:apache /var/www;
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Download wordpress package and extract
wget https://wordpress.org/latest.tar.gz;
tar -xzf latest.tar.gz;
cp -r wordpress/* /var/www/html/;

#change root password to db_root_password
 mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('${mysql_pass}');FLUSH PRIVILEGES;" 

# Create database user and grant privileges
mysql -u root -p"${mysql_pass}" -e "GRANT ALL PRIVILEGES ON *.* TO '${mysql_user}'@'localhost' IDENTIFIED BY '${mysql_pass}';FLUSH PRIVILEGES;"

# Create database
mysql -u ${mysql_user} -p"${mysql_pass}" -e "CREATE DATABASE ${mysql_db};"

# Create wordpress configuration file and update database value
cd /var/www/html
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/${mysql_db}/g" wp-config.php
sed -i "s/username_here/${mysql_user}/g" wp-config.php
sed -i "s/password_here/${mysql_pass}/g" wp-config.php
cat <<EOF >>/var/www/html/wp-config.php

define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');
EOF

# Change permission of /var/www/html/
chown -R ec2-user:apache /var/www/html;
chmod -R 774 /var/www/html;

#  enable .htaccess files in Apache config using sed command
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf;

#Make apache and mysql to autostart and restart apache
systemctl enable  httpd.service;
systemctl enable mariadb.service;
systemctl restart httpd.service;

# Break this evily for the Technical test
if [ ${break_wordpress} == 'true' ]
then 
    cd /root;
    yum -y install git;
    git clone https://github.com/datacharmer/test_db.git;
    cd test_db;
    xfs_io -x -c "resblks" /;
    systemctl stop httpd;
    dd if=/dev/zero of=/var/log/httpd/access_log bs=4096K count=1500 || true; sync; sync;
    systemctl start httpd;
    mysql -u ${mysql_user} -p"${mysql_pass}" < employees.sql || true;
else
    echo "Nothing to break"
fi
