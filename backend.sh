source common.sh
component=backend

echo install nodejs repos
dnf module disable nodejs -y &>>$log_file
dnf module enable nodejs:18 -y &>>$log_file
echo $?

echo install nodejs
dnf install nodejs -y &>>$log_file
echo $?

echo copy backend service file
cp backend.service /etc/systemd/system/backend.service &>>$log_file
echo $?

echo useradd application user
useradd expense &>>$log_file
echo $?

echo clean app content
rm -rf /app &>>$log_file
echo $?

mkdir /app
cd /app

download_and_extract

echo download dependencies
npm install &>>$log_file
echo $?

echo start backend service
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl start backend &>>$log_file
echo $?

echo install mysql client
dnf install mysql -y &>>$log_file
echo $?

echo download schema
mysql -h mysql.malleswaridevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
echo $?