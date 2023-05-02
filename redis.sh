script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>> Install Redis Repos <<<<<<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Install Redis <<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y &>>$log_file
func_status_check $?
yum install redis -y &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Update Redis Listen Address <<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Start Redis Service <<<<<<<<\e[0m"
systemctl enable redis &>>$log_file
func_status_check $?
systemctl restart redis &>>$log_file
func_status_check $?

