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
SCRIPT_DIR=$PWD

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

NODEJS_SETUP(){
    dnf module disable nodejs -y &>>LOG_FILE
    VALIDATE $? "Disabling Nodejs Default version"

    dnf module enable nodejs:20 -y &>>LOG_FILE
    VALIDATE $? "Enablling Nodejs version 20"

    dnf install nodejs -y &>>LOG_FILE
    VALIDATE $? "Installing Nodejs"

    npm install &>>LOG_FILE
    VALIDATE $? "Installing Nodejs dependencies"
}

MAVEN_SETUP(){
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "Installing Maven"

    mvn clean package &>>$LOG_FILE
    VALIDATE $? "Packaging the shipping application"
    mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
    VALIDATE $? "Renaming the shipping jar file"
}


APP_SETUP(){
    mkdir -p /opt/app
    VALIDATE $? "Creating App Directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip 
    VALIDATE $? "Downloading $app_name.zip"

    rm -rf /opt/app/*

    cd /opt/app
    unzip /tmp/$app_name.zip 
    VALIDATE $? "Unzipping $app_name.zip"

    id roboshop 
    if [ $? -ne 0 ]
    then 
        useradd --system --home /opt/app --shell /sbin/nologin --comment "System User" roboshop
        VALIDATE $? "Creating roboshop user"
    else 
        echo "User Roboshop already exixts"
    fi

}

SYSTEMD_SETUP(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copying $app_name.service file"

    systemctl daemon-reload &>>$LOG_FILE
    systemctl enable $app_name &>>$LOG_FILE
    systemctl start $app_name &>>$LOG_FILE
    VALIDATE $? "Enabling and starting $app_name service"
}

PRINT_TIME(){
    END_TIME=$(date +%s)
    DIFF=$(($END_TIME - $START_TIME))
    echo -e "Script execution time is$Y $DIFF seconds $N" | tee -a $LOG_FILE
}