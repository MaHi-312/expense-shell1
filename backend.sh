log_file=/tmp/expense.log

echo install nodejs repos
dnf module disable nodejs -y >>$log_file
dnf module enable nodejs:18 -y >>$log_file

echo install nodejs
dnf install nodejs -y >>$log_file

echo copy backend service file
cp backend.service /etc/systemd/system/backend.service >>$log_file
echo useradd application user
useradd expense >>$log_file
echo clean app content
rm -rf /app >>$log_file

mkdir /app

echo download app content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip >>$log_file
cd /app
echo extract app content
unzip /tmp/backend.zip >>$log_file

echo download dependencies
npm install >>$log_file
echo start backend service
systemctl daemon-reload >>$log_file
systemctl enable backend >>$log_file
systemctl start backend >>$log_file

echo install mysql client
dnf install mysql -y >>$log_file
echo download schema
mysql -h mysql.malleswaridevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql >>$log_file