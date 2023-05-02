script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh

yum install nginx -y  &>>$log_file
func_status_check $?
cp roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$log_file
func_status_check $?
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check $?
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?
systemctl restart nginx &>>$log_file
systemctl enable nginx  &>>$log_file
func_status_check $?


