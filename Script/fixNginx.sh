# 2021 - Nguyen Nhat Linh
# Tong hop khi tim hieu OpenedX

#!/bin/bash

show_help(){
    echo -e "
Usage: restartPlatform.sh [OPTION]\nMain options:
    -s  Start nginx service. Should be use when server error (after restart)
    -r  Restart nginx service. Should be use when server crash\n
For example: ./fixNginx -s\nHelp option:
    -h  Help
    "
}

while getopts :s:r:h flag
do
    case "$flag" in
        s) #restart lms
            service nginx start
        ;;
        r) #restart cms
            pkill -9 nginx && nginx -c /etc/nginx/nginx.conf && nginx -s reload
        ;;
        h) #help
            show_help
        ;;
        \?)
            echo "Invalid option: -$OPTARG. USE -h flag for help."
            exit
        ;;
    esac
done