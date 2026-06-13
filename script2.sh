#!/bin/bash

OS=$(cat /etc/os-release | grep "^NAME" | cut -d= -f2 | tr -d '"')

if echo "$OS" | grep -qi "ubuntu\|debian"; then
    apt update -y && apt install -y apache2
    systemctl start apache2 && systemctl enable apache2
elif echo "$OS" | grep -qi "centos\|rhel\|amazon"; then
    dnf install -y httpd || yum install -y httpd
    systemctl start httpd && systemctl enable httpd
fi
