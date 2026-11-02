#!/bin/bash
source ./common.sh

root_check

app_name="catalogue"

app_setup
nodejs_setup
systemd_setup


cp $scripts_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$logs_file
validation $? "Loading Master Data(MongoDB)"

dnf install mongodb-mongosh -y &>>$logs_file
validation $? "Installing MongoDB Client"

product_count=$(mongosh --host "mongodb.$domain_name" --quiet --eval 'db.getSiblingDB("catalogue").products.countDocuments()' 2>> "$logs_file") 
validation $? "Connecting to MongoDB"

if [ "$product_count" -eq 0 ]; then
    mongosh --host "mongodb.$domain_name" </app/db/master-data.js &>>$logs_file
    validation $? "Loading products"
else
    echo -e "$(timestamp) [INFO] Data has been already loaded so ${Y}SKIPPING...${N}"
fi

restart
total_time_taken








