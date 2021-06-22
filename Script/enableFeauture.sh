#!/bin/bash

# cp logo png to default theme /edx/app/edxapp/edx-platform/lms/static/images
#sed -i -e "s/ENABLE_COMPREHENSIVE_THEMING:.*/ENABLE_COMPREHENSIVE_THEMING: true/" /edx/etc/lms.yml
echo "Change Logo"
sudo cp /edx/app/edxapp/edx-platform/lms/static/images/logo.png /edx/app/edxapp/edx-platform/lms/static/images/logo.png.bak
sudo cp /home/bebu/BlendedLearning/logo.png /edx/app/edxapp/edx-platform/lms/static/images/logo.png
./compileStaticAssets.sh

echo "Change value on lms.yml and studio.yml"
sed -i "s/ENABLE_SPECIAL_EXAMS.*/ENABLE_SPECIAL_EXAM: true/" /edx/etc/lms.yml
sed -i "s/ENABLE_SPECIAL_EXAMS.*/ENABLE_SPECIAL_EXAM: true/" /edx/etc/studio.yml
sed -i "s/ENABLE_OTHER_COURSE_SETTINGS.*/ENABLE_OTHER_COURSE_SETTINGS: true/" /edx/etc/studio.yml
sed -i "s/MILESTONES_APP.*/MILESTONES_APP: true/" /edx/etc/lms.yml
sed -i "s/MILESTONES_APP.*/MILESTONES_APP: true/" /edx/etc/studio.yml
sed -i "s/ENTRANCE_EXAMS.*/ENTRANCE_EXAMS: true/" /edx/etc/lms.yml
sed -i "s/ENTRANCE_EXAMS.*/ENTRANCE_EXAMS: true/" /edx/etc/studio.yml
sed -i "s/CUSTOM_COURSES_EDX.*/CUSTOM_COURSES_EDX: true/" /edx/etc/lms.yml
sed -i "s/CUSTOM_COURSES_EDX.*/CUSTOM_COURSES_EDX: true/" /edx/etc/studio.yml
sed -i "s/ENABLE_EDXNOTES.*/ENABLE_EDXNOTES: true/" /edx/etc/studio.yml
sed -i "s/ENABLE_EDXNOTES.*/ENABLE_EDXNOTES: true/" /edx/etc/lms.yml
sed -i "s/ENABLE_OAUTH2_PROVIDER.*/ENABLE_OAUTH2_PROVIDER: true/" /edx/etc/lms.yml
sed -i "s/ENABLE_OAUTH2_PROVIDER.*/ENABLE_OAUTH2_PROVIDER: true/" /edx/etc/studio.yml
sed -i "s/ENABLE_SPECIAL_EXAMS.*/ENABLE_SPECIAL_EXAMS: true/" /edx/etc/lms.yml
sed -i "s/ENABLE_SPECIAL_EXAMS.*/ENABLE_SPECIAL_EXAMS: true/" /edx/etc/studio.yml

# Run migrate database
sudo -H -u edxapp bash << EOF
source /edx/app/edxapp/edxapp_env
cd /edx/app/edxapp/edx-platform
python ./manage.py lms migrate
python ./manage.py cms migrate
exit
EOF

./restartPlatform.sh -a