source common.sh
component=backend

echo install nodejs repos
dnf module disable nodejs -y &>>$log_file
dnf module enable nodejs:18 -y &>>$log_file
stat_check

echo install nodejs
dnf install nodejs -y &>>$log_file
stat_check

echo copy backend service file
cp backend.service /etc/systemd/system/backend.service &>>$log_file
stat_check

echo useradd application user
id expense &>>$log_file
if [ $? -ne 0 ]; then
   useradd expense &>>$log_file
fi
stat_check

echo clean app content
rm -rf /app &>>$log_file
stat_check

mkdir /app
cd /app

download_and_extract

echo download dependencies
npm install &>>$log_file
stat_check

echo start backend service
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl start backend &>>$log_file
stat_check

echo install mysql client
dnf install mysql -y &>>$log_file
stat_check

echo load schema
mysql_root_password = $1
mysql -h mysql.malleswaridevops.online -uroot -p$mysql_root_password < /app/schema/backend.sql &>>$log_file
stat_check