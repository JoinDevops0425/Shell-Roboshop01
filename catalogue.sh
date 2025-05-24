#!/bin/bash

source ./common.sh
app_name="catalogue"

CHECK_ROOT
APP_SETUP
NODEJS_SETUP
SYSTEMD_SETUP

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongod.repo
VALIDATE $? "Copying MongoDB Repo file"

dnf install mongodb-mongosh -y &>>LOG_FILE
VALIDATE $? "Installing MongoDB client"

STATUS=$(mongosh --host mongodb.persistent.sbs --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $STATUS -lt 0 ]
then 
    mongosh --host mongodb.persistent.sbs </opt/app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Inputing catalogue database"
else 
    echo "Catalogue database already exists"
fi    

PRINT_TIME