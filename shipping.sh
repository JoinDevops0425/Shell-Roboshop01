#!/bin/bash
source ./common.sh
CHECK_ROOT
app_name="shipping"
APP_SETUP
SYSTEMD_SETUP

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing mysql client"

mysql -h mysql.persistent.sbs -u root -pRoboShop@1 -e 'use cities' &>>$LOG_FILE

if [ $? -ne 0 ]
then
    mysql -h mysql.persistent.sbs -uroot -pRoboShop@1 < /opt/app/db/schema.sql
    mysql -h mysql.persistent.sbs -uroot -pRoboShop@1 < /opt/app/db/app-user.sql 
    mysql -h mysql.persistent.sbs -uroot -pRoboShop@1 < /opt/app/db/master-data.sql
else 
    echo "Database already exists"
fi

systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "Restarting the shipping service"

PRINT_TIME



