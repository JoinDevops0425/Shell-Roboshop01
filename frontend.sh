#!/bin/bash

source ./common.sh
CHECK_ROOT

dnf module disable nginx -y &>>LOG_FILE
VALIDATE $? "Disabling Nginx default version"

dnf module enable nginx:1.24 -y &>>LOG_FILE
VALIDATE $? "Enabling Nginx version 1.24"

dnf install nginx -y &>>LOG_FILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enabling Nginx Service"

systemctl start nginx &>>LOG_FILE
VALIDATE $? "Starting Nginx Service"

rm -rf /usr/share/nginx/html/* 

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip

cd /usr/share/nginx/html
VALIDATE $? "Changing directory to Nginx HTML folder"
unzip /tmp/frontend.zip 
VALIDATE $? "Unzipping frontend.zip"

rm -rf /etc/nginx/nginx.coinf
VALIDATE $? "Removing old nginx.conf file"



cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf

VALIDATE $? "Copying nginx.conf to Nginx folder"

systemctl restart nginx &>>LOG_FILE

PRINT_TIME



