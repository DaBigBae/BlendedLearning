#!/bin/bash

USER=${1}
PASS=${2}
SERVER="smtp.gmail.com"
PORT=587
TLS="true"

show_help(){
    echo "
Usage: SMTP.sh [EMAILADDRESS] [PASSWORD] [OPTION]\nMain options:
    -s Email server (Default is smtp.gmail.com)
    -p Port email host service (Default is 587)
    -t Don't use TLS when transmit email
For example: ./SMTP.sh test@gmail.com yourpass\nHelp option:
    -h  Help
    "
}

OPTIND=3
while getopts :s:pt:h flag
do
    case "$flag" in
        s) #Email server
            SERVER=$OPTARG
        ;;
        p) #Email service port
            PORT=$OPTARG
        ;;
        t) #Use TLS when transmit email
            TLS="false"
        h) #help
            show_help
        ;;
        \?)
            echo "Invalid option: -$OPTARG. USE -h flag for help."
            exit
        ;;
    esac
done

sed -i "s/"EMAIL_HOST_PASSWORD"/"EMAIL_HOST_PASSWORD": "$PASS",/" /edx/etc/lms.yml
sed -i "s/"EMAIL_HOST_USER"/"EMAIL_HOST_USER": "$USER",/" /edx/etc/lms.yml

sed -i "s/"EMAIL_HOST_PASSWORD"/"EMAIL_HOST_PASSWORD": "$PASS",/" /edx/etc/studio.yml
sed -i "s/"EMAIL_HOST_USER"/"EMAIL_HOST_USER": "$USER",/" /edx/etc/studio.yml

sed -i "s/"EMAIL_BACKEND"/"EMAIL_BACKEND": "django.core.mail.backends.smtp.EmailBackend",/" /edx/etc/lms.yml
sed -i "s/"EMAIL_HOST"/"EMAIL_HOST": "$SERVER",/" /edx/etc/lms.yml
sed -i "s/"EMAIL_PORT"/"EMAIL_PORT": "$PORT",/" /edx/etc/lms.yml
sed -i "s/"EMAIL_USE_TLS"/"EMAIL_USE_TLS": "$TLS",/" /edx/etc/lms.yml

sed -i "s/"EMAIL_BACKEND"/"EMAIL_BACKEND": "django.core.mail.backends.smtp.EmailBackend",/" /edx/etc/studio.yml
sed -i "s/"EMAIL_HOST"/"EMAIL_HOST": "$SERVER",/" /edx/etc/studio.yml
sed -i "s/"EMAIL_PORT"/"EMAIL_PORT": "$PORT",/" /edx/etc/studio.yml
sed -i "s/"EMAIL_USE_TLS"/"EMAIL_USE_TLS": "$TLS",/" /edx/etc/studio.yml

/edx/bin/supervisorctl restart lms
/edx/bin/supervisorctl restart cms
/edx/bin/supervisorctl restart edxapp_worker: