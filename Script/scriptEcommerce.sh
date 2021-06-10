# 2021 - Nguyen Nhat Linh
# Tong hop khi tim hieu OpenedX

#!/bin/bash

sed -i -e "s/.*ENABLE_OAUTH2_PROVIDER.*/ENABLE_OAUTH2_PROVIDER: true/" /edx/etc/lms.yml
sed -i -e "s/.*PAID_COURSE_REGISTRATION_CURRENCY.*/PAID_COURSE_REGISTRATION_CURRENCY: ["usd","$"]/" /edx/etc/lms.yml
sed -i -e "s/.*PDF_RECEIPT_BILLING_ADDRESS.*/PDF_RECEIPT_BILLING_ADDRESS: "Nhập địa chỉ nhận biên lai của bạn\nở đây.\n"/" /edx/etc/lms.yml
sed -i -e "s/.*PDF_RECEIPT_COBRAND_LOGO_PATH.*/PDF_RECEIPT_COBRAND_LOGO_PATH: ""/" /edx/etc/lms.yml
sed -i -e "s/.*PDF_RECEIPT_DISCLAIMER_TEXT.*/PDF_RECEIPT_DISCLAIMER_TEXT: ""/" /edx/etc/lms.yml
sed -i -e "s/.*PDF_RECEIPT_FOOTER_TEXT.*/PDF_RECEIPT_FOOTER_TEXT: ""/" /edx/etc/lms.yml
sed -i -e "s/.*PDF_RECEIPT_LOGO_PATH.*/PDF_RECEIPT_LOGO_PATH: ""/" /edx/etc/lms.yml
sed -i -e "s/.*PDF_RECEIPT_TAX_ID.*/PDF_RECEIPT_TAX_ID: ""/" /edx/etc/lms.yml
sed -i -e "s/.*PDF_RECEIPT_TAX_ID_LABEL.*/PDF_RECEIPT_TAX_ID_LABEL: ""/" /edx/etc/lms.yml
sed -i -e "s/.*PDF_RECEIPT_TERMS_AND_CONDITIONS.*/PDF_RECEIPT_TERMS_AND_CONDITIONS: ""/" /edx/etc/lms.yml

