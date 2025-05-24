#!/bin/bash

source ./common.sh
app_name=mongodb

CHECK_ROOT

cp mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "Copying MongoDB Repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installng Mongo DB"

systemctl enable mongod &>>LOG_FILE
VALIDATE $? "Enabling MongoDB Server"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "Starting MongoDB Server"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
VALIDATE $? "Updating Mongo Config file"

systemctl restart mongod &>>LOG_FILE
VALIDATE $? "Restartoing MongoDB Server"

PRINT_TIME


