#!/bin/bash

echo 1 | sudo -S -H -u edxapp bash
source /edx/app/edxapp/edxapp_env
# Chuyển vùng làm việc về thư mục edx-platform
cd /edx/app/edxapp/edx-platform

# Chạy 1 trong hai lệnh sau để tạo tài khoản
#python ./manage.py lms manage_user CITDAdmin admin@citd.vn --staff --superuser --settings=production
python ./manage.py lms --settings production createsuperuser
echo username
echo email
echo pass1
echo pass2
# Chạy lệnh sau để đổi pass
python ./manage.py lms --settings production changepassword CITDAdmin