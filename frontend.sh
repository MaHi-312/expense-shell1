source common.sh
component=frontend

echo install nginx
dnf install nginx -y  &>>$log_file
echo $?
echo placing expense config file in nginx
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
echo $?

echo remove old nginx content
rm -rf /usr/share/nginx/html/* &>>$log_file
echo $?

cd /usr/share/nginx/html &>>$log_file

download_and_extract

echo starting nginx services
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
echo $?