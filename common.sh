#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script started executeing at : $(date)" | tee -a $LOG_FILE

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then 
        echo -e "$R Error : Please run as a root user$N" | tee -a $LOG_FILE
        exit 1
    else 
        echo "You are running as a root user" | tee -a $LOG_FILE
    fi
}
VALIDATE(){

    if [ $1 -eq 0 ]
    then 
        echo -e "$2 is $G susccessful$N" | tee -a $LOG_FILE
    else 
        echo -e "$2 is $R failed$N" | tee -a $LOG_FILE
        exit 1
    fi    
}

PRINT_TIME(){
    END_TIME=$(date +%s)
    DIFF=$(($END_TIME - $START_TIME))
    echo -e "Script execution time is$Y $DIFF seconds $N" | tee -a $LOG_FILE
}