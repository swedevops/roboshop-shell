script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>> Install nginx <<<<<<<<\e[0m"
yum install nginx -y  &>>$log_file
func_status_check $?
echo -e "\e[36m>>>>>>>>> Copy File <<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$log_file
func_status_check $?
echo -e "\e[36m>>>>>>>>> Remove Files <<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check $?
echo -e "\e[36m>>>>>>>>> Download Application <<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?
cd /usr/share/nginx/html
echo -e "\e[36m>>>>>>>>> Unzip File <<<<<<<<\e[0m"
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?
echo -e "\e[36m>>>>>>>>>Nginx Services <<<<<<<<\e[0m"
systemctl restart nginx &>>$log_file
systemctl enable nginx  &>>$log_file
func_status_check $?


