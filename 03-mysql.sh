#!/bin/bash
source ./common.sh

root_check

dnf module enable mysql:8.4 -y &>>$logs_file
dnf install mysql-server -y &>>$logs_file
validation $? "Enable MySQLl 8.4 and install MySQL server "


mysql_secure_installation --set-root-pass RoboShop@1 &>>$logs_file
validation $? "Setup Root-Pass"

systemctl enable mysqld &>>$logs_file
systemctl start mysqld &>>$logs_file
validation $? "ENABLE and START MYSQL"


total_time_taken




