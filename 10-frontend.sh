#!/bin/bash

source ./common.sh

root_check
 
dnf module disable nginx -y &>>$logs_file
dnf module enable nginx:1.26 -y &>>$logs_file
dnf install nginx -y &>>$logs_file
validation $? "Installing nginx"

systemctl enable nginx &>>$logs_file
systemctl start nginx &>>$logs_file
validation $? "Enable and start nginx"

rm -rf /usr/share/nginx/html/* &>>$logs_file
validation $? "Removing default nginx content"

curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/frontend-v4.zip &>>$logs_file
cd /usr/share/nginx/html &>> $logs_file
unzip /tmp/frontend.zip &>> $logs_file
validation $? "Downloading and unzipping frontend code"

sed -i "s/DOMAIN_NAME/$domain_name/g" "$scripts_dir/roboshop.conf"
cp "$scripts_dir/roboshop.conf" /etc/nginx/default.d/roboshop.conf
validation $? "Copied roboshop config"

nginx -t &>> $logs_file
validation $? "Nginx Configuration"

systemctl restart nginx
validation $? "Restarting nginx"

total_time_taken