#!/bin/bash

app_name="redis"

source ./common.sh
CHECK_ROOT


dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling Redis default version"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling Redis version 7"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Updating Redis config file"

systemctl restart redis &>>$LOG_FILE
VALIDATE $? "Restarting Redis service"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling Redis service"

systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting Redis service"

PRINT_TIME
