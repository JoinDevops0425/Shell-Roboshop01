#!/bin/bash
source ./common.sh
app_name="mysql"
CHECK_ROOT
dnf install mysql-server -y &>>$LOG_FILE   
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Starting MySQL Server"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "Setting MySQL root password"

PRITN_TIME
