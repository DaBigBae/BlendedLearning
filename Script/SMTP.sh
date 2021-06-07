#!/bin/bash

MAIL=''
PASS=''
SERVER="smtp.gmail.com"
PORT=587
TLS="true"

show_help(){
    echo "
Usage: SMTP.sh [-e EMAILADDRESS] [-p PASSWORD] [OPTION]
Main options:
    -e Your service email you want to setup
    -p Your email password
    -s Email server (Default is smtp.gmail.com)
    -o Port email host service (Default is 587)
    -t Don't use TLS when transmit email
For example: ./SMTP.sh test@gmail.com yourpass
Help option:
    -h  Help
    "
}

while getopts :e:p:s:ot:h flag
do
    case "$flag" in
        e) #Email
            MAIL=$OPTARG
        ;;
        p) #Password
            PASS=$OPTARG
        ;;
        s) #Email server
            SERVER=$OPTARG
        ;;
        o) #Email service port
            PORT=$OPTARG
        ;;
        t) #Use TLS when transmit email
            TLS="false"
        ;;
        h) #help
            show_help
            exit 1
        ;;
        *)
            echo "Invalid option: -$OPTARG. USE -h flag for help."
            exit 1
        ;;
    esac
done

echo -e ">>> Change value in /edx/etc/lms.yml and /edx/etc/studio.yml\n"
sed -i -e "s/.*EMAIL_HOST_PASSWORD.*/EMAIL_HOST_PASSWORD: $PASS/" /edx/etc/lms.yml
sed -i -e "s/.*EMAIL_HOST_USER.*/EMAIL_HOST_USER: $MAIL/" /edx/etc/lms.yml

sed -i -e "s/.*EMAIL_HOST_PASSWORD.*/EMAIL_HOST_PASSWORD: $PASS/" /edx/etc/studio.yml
sed -i -e "s/.*EMAIL_HOST_USER.*/EMAIL_HOST_USER: $MAIL/" /edx/etc/studio.yml

sed -i -e "s/.*EMAIL_BACKEND.*/EMAIL_BACKEND: django.core.mail.backends.smtp.EmailBackend/" /edx/etc/lms.yml
sed -i -e "s/.*EMAIL_HOST\W.*/EMAIL_HOST: $SERVER/" /edx/etc/lms.yml
sed -i -e "s/.*EMAIL_PORT.*/EMAIL_PORT: $PORT/" /edx/etc/lms.yml
sed -i -e "s/.*EMAIL_USE_TLS.*/EMAIL_USE_TLS: $TLS/" /edx/etc/lms.yml

sed -i -e "s/.*EMAIL_BACKEND.*/EMAIL_BACKEND: django.core.mail.backends.smtp.EmailBackend/" /edx/etc/studio.yml
sed -i -e "s/EMAIL_HOST\W.*/EMAIL_HOST: $SERVER/" /edx/etc/studio.yml
sed -i -e "s/.*EMAIL_PORT.*/EMAIL_PORT: $PORT/" /edx/etc/studio.yml
sed -i -e "s/.*EMAIL_USE_TLS.*/EMAIL_USE_TLS: $TLS/" /edx/etc/studio.yml

echo -e ">>> Restarting Open edX platform...\n"
/edx/bin/supervisorctl restart lms
/edx/bin/supervisorctl restart cms
/edx/bin/supervisorctl restart edxapp_worker: