#!/bin/bash
echo "Hello from Terraform runtime script!" > /var/www/html/index.html
apt-get update
apt-get install -y apache2
systemctl start apache2
