#!/bin/bash
dnf install -y httpd
systemctl enable httpd
systemctl start httpd
echo "Hello" >/var/www/html/index.html
