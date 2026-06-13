#!/bin/bash

OS=$(cat /etc/os-release | grep "^NAME" | cut -d= -f2 | tr -d '"')

if echo "$OS" | grep -qi "ubuntu\|debian"; then
    apt update -y
    apt install -y apache2 mysql-server php libapache2-mod-php php-mysql
    systemctl enable apache2 mysql
    systemctl start apache2 mysql
elif echo "$OS" | grep -qi "centos\|rhel\|amazon"; then
    PKG=$(command -v dnf &>/dev/null && echo dnf || echo yum)
    $PKG install -y httpd mariadb-server php php-mysqlnd
    systemctl enable httpd mariadb
    systemctl start httpd mariadb
fi

echo "<?php phpinfo(); ?>" > /var/www/html/info.php
