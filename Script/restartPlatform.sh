# 2021 - Nguyen Nhat Linh
# Tong hop khi tim hieu OpenedX

#!/bin/bash

restartPlatform(){
    # These are the commands for restarting the LMS and CMS beginning with Gingko
    /edx/bin/supervisorctl restart lms
    /edx/bin/supervisorctl restart cms

    # If youre running a previous version of Open edX then use this command instead
    #/edx/bin/supervisorctl restart edxapp:
    /edx/bin/supervisorctl restart edxapp_worker:
}

show_help(){
    echo "
Usage: restartPlatform.sh [-l] [-c] [-w] [-a] [-h]

Main options:
    -l  Restart LMS
    -c  Restart CMS
    -w  Restart edxapp_worker
    -a  Restart LMS, CMS and edxapp_worker

For example: ./restartPlatform.sh -l

Help option:
    -h  Help
    "
}

if (! getopts :lcwah flag);
then
    show_help
    exit 1
fi

while getopts :lcwah flag;
do
    case "$flag" in
        l) #restart lms
            /edx/bin/supervisorctl restart lms
        ;;
        c) #restart cms
            /edx/bin/supervisorctl restart cms
        ;;
        w) #restart edxapp_worker
            /edx/bin/supervisorctl restart edxapp_worker:
        ;;
        a) #restart lms, cms and edxapp_worker
            restartPlatform
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