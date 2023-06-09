script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_user=$1
if [ -z "$mysql_root_user" ]
then
  echo mysql root password missing
  exit
  fi


echo -e "\e[36m>>>>>>>>> Disable MySQL 8 Version <<<<<<<<\e[0m"
dnf module disable mysql -y &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Copy MySQL Repo File <<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Install MySQL <<<<<<<<\e[0m"
yum install mysql-community-server -y &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Start MySQL <<<<<<<<\e[0m"
systemctl enable mysqld &>>$log_file
func_status_check $?
systemctl restart mysqld &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Reset MySQL Password <<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_user} &>>$log_file
func_status_check $?
