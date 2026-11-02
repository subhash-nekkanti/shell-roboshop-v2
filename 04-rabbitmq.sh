#!/bin/bash

source ./common.sh

root_check

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validation $? "Adding Rabbitmq Repo"

dnf install erlang rabbitmq-server -y &>>$logs_file
validation $? "Installing RabbitMQ server"

systemctl enable rabbitmq-server &>>$logs_file
systemctl start rabbitmq-server &>>$logs_file
validation $? "Start and Enable RabbtiMQ server"

#Idempotency: A script or program should give same result irrespective of no of times we run or retries the script


rabbitmqctl list_users | grep -qw "roboshop"                    #if systemuser already exists and if we run this script multiple times it throws error for adding user
if [ $? -ne 0 ]; then                                           #so check if user already exist or nor with command "rabbitmq ctl list_users | grep -qw "roboshop" and check exit status 
    rabbitmqctl add_user roboshop roboshop123 &>>$logs_file      #if exit status is 0 then user already exist and skip creating user. If $? =1 then create a user which means user doesnot exist
    validation $? "creating system RabbitMQ user for RoboShop"
else
    echo -e "$(timestamp) [INFO] : User already exist ${Y}SKIPPING...${N}" 
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$logs_file
validation $? "Set Permissions for system user" 

total_time_taken




