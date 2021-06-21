# Thông tin về các cổng trong hệ thống Open edX:
|   Service   | Port  |
| :---------: | :---: |
|   LMS(*)    |  80   |
|   CMS(*)    | 18010 |
|    Notes    | 18120 |
|    Certs    | 18090 |
|  Discovery  | 18381 |
|  Ecommerce  | 18130 |
| edx-release | 8099  |
|    Forum    | 18080 |
|   Xqueue    | 18040 |

> Các hệ thống chính:

* LMS - Learning Managerment System

* CMS - Course Managerment System.

Sau khi cài đặt hệ thống, các file chứa password sẽ nằm tại đường dẫn `/root/my-password.txt`

# Các thư mục quan trọng của edX platform
| Thư mục                                      | Mô tả                                        |
| -------------------------------------------- | -------------------------------------------- |
| `/edx/app`                                   | Nơi chứa các các file cho tất cả các module  |
| `/edx/app/edx_ansible`                       | Nơi chứa tệp server-vars.yml                 |
| `/edx/app/edx_ansible/edx_ansible/playbooks` | Chứa các file Ansible playbook               |
| `/edx/app/edxapp/edx-platform/themes`        | Nơi chứa các theme giao diện cho hệ thống    |
| `/edx/bin`                                   | Nơi chứa các file pip, ansible và bash admin |
| `/edx/etc`                                   | Các file cấu hình cho tất cả module của edX  |
| `/edx/var`                                   | Chứa dữ liệu của hệ thống (app, logs,...)    |

# Sau khi cài đặt

## 1. Tạo tài khoản superuser/staff (bắt buộc)

```
$ sudo -H -u edxapp bash
$ source /edx/app/edxapp/edxapp_env
# Chuyển vùng làm việc về thư mục edx-platform:
$ cd /edx/app/edxapp/edx-platform

# Chạy lệnh sau để tạo tài khoản:
# python ./manage.py lms manage_user CITDAdmin <email> --staff --superuser --settings=production
$ python ./manage.py lms --settings production createsuperuser

# Nếu muốn thay đổi password, chạy lệnh sau:
$ python ./manage.py lms --settings production changepassword <username>
```

Bước này không bắt buộc:
Có thể add user ubuntu vào 2 group Open edX Linux, nhằm đơn giản hoá trong quá trình làm việc
```
$ sudo usermod -aG www-data <username>
$ sudo usermod -aG edxapp <username>
```

## 2. Đổi ngôn ngữ của hệ thống

Hiện tại dự án dịch thuật hệ thống Open edX trên transifex đang tạm ngưng
Phần lớn hệ thống đã được translate qua tiếng việt.
Chạy lệnh sau để cập nhật ngôn ngữ:
```
$ sudo -H -u edxapp bash
$ source /edx/app/edxapp/edxapp_env
$ cd /edx/app/edxapp/edx-platform
$ paver i18n_dummy
```
Lệnh paver trên sẽ cài đặt các ngôn ngữ được liệt kê sẵn trong mục `locales`
của file `config.yml` nằm tại đường dẫn `/edx/app/edxapp/edxplatform/conf/locale/config.yml`. Nếu không muốn cài đặt ngôn ngữ nào thì có thể đặt comment (#) trước ngôn ngữ không muốn cài đặt.

Truy cập vào \<yourLMS>/update_lang/ -> Nhập code ngôn ngữ (vi cho Tiếng Việt) -> Submit

## 3. Đổi favicon, logo...
Thay thế logo mặc định tại `/edx/app/edxapp/edx-platform/lms/static/images`, file logo mới nên được đặt tên là logo.png
Chạy lệnh sau để hoàn tất cài đặt (yêu cầu quyền root)
```
$ sudo ./compileStaticAssets.sh
```

## 4. Setup SMTP email
- Truy cập https://myaccount.google.com/lesssecureapps (nếu sử dụng gmail) và thay đổi cài đặt cho lựa chọn "Allow less secure apps" về "on".
- Chạy script sau để cài nhanh (áp dụng với gmail)
```
$ sudo ./SMTP.sh -e <EMAILADDRESS> -p <PASSWORD>
```
- Chạy lệnh trên với option -h để biết thêm các lựa chọn khác

## 5. Install Notes and Annotations
- Tạo superuser cho edx-notes
```
$ sudo -H -u edxapp bash
$ source /edx/app/edxapp/edxapp_env
$ cd /edx/app/edxapp/edx-platform
$ python ./manage.py lms --settings production createsuperuser
# Nên đặt tên edxnotes_worker
```
Truy cập \<yourLMS>/admin/oauth2_provider/application/ -> thêm 2 application (edxnotes-backend-service và edxnotes-sso), như sau:
```
>>> backend-service:
Client ID, Client secret và Name: setup tuỳ ý
User: chọn service worker
Client type: Confidential
Authorization: client credentials

>>> sso:
Client ID, Client secret và Name: setup tuỳ ý
User: chọn service worker
Redirect Uris: https://<service_url>/complete/edx-oauth2/
Client type: confidential
Authorization: Authorization code
Đánh dấu tick ô Skip authorization
```
Client ID và Client secret sso sẽ dùng cho sau, nên lưu lại.

Truy cập \<yourLMS>/admin/oauth_dispatch/applicationaccess/ -> thêm 2 application vừa tạo vào danh sách:
```
Application: service-backend/sso
Scopes: user_id
```

Chạy script sau để cấu hình và cài đặt Notes: `scriptNotesAndAnnotations.sh -p MYSQLPASS -k SECRETKEY -i CLIENTID -s CLIENTSECRET`

## 6. Install Ecommerce

# Delete a course
```
source /edx/app/edxapp/edxapp_env
cd /edx/app/edxapp/edx-platform
python manage.py cms dump_course_ids --settings=production # this command return courseID
python manage.py cms delete_course <COURSE_ID> --settings=devstack 
```

# Troubleshoot
> Lỗi Uh oh, we are having some server issues:

Nếu sau khi cài đặt hoặc khởi động lại server gặp lỗi này khi truy cập LMS hay CMS thì chạy lệnh sau và kiểm tra lại:
```
$ sudo <path>/fixNginx.sh -s
```
Nếu vẫn không truy cập được hệ thống, chạy lệnh sau để chạy lại cấu hình Nginx:
```
$ sudo <path>/fixNginx.sh -r
```

# Tài liệu tham khảo
[Lauren Mc Daniel's Blog](https://blog.lawrencemcdaniel.com/category/open-edx/) - Các bài viết về việc cấu hình, cài đặt Open edX trên AWS-3

[Offical Document's Open edX](https://docs.edx.org/) - Trang document chính thức của Open edX

[Open edX Document: Install, config...](https://edx.readthedocs.io/projects/edx-installing-configuring-and-running/en/latest/) - Document của Open edX về cài đặt, cấu hình và duy trì hệ thống

[Open edX Course Catalog API user guide](http://course-catalog-api-guide.readthedocs.io/en/latest/) - Document cho api admin

[Open edX api docs]() - http://\<LMS or CMS>/api_docs/

[Open edX api admin]() - http://\<LMS or CMS>/api_admin
