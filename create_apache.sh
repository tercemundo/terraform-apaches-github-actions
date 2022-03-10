#! /bin/bash

sudo su
yum -y install httpd
echo "<p> Ahmed Enes Turan 2022 </p>" >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd