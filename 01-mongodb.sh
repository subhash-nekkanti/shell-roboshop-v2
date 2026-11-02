#!/bin/bash

source ./common.sh

root_check

cp mongo.repo /etc/yum.repos.d/mongo.repo
validation $? "adding mongo repo"

dnf install mongodb-org -y &>>logs_file
validation $? "MongoDB installation"

systemctl enable mongod &>>logs_file
systemctl start mongod &>>logs_file
validation $? "starting and enabling MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf   #sed-streamline editor, -i make changes permanantly s--> substitute
validation $? "updating remote configuation"     #127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

systemctl restart mongod  #restarting mongoDB
validation $? "Restarting mongoDB"

total_time_taken

