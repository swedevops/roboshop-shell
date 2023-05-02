script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> copy systemd file <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?
echo -e "\e[36m>>>>>>>>> Install mongodb <<<<<<<<\e[0m"
yum install mongodb-org -y  &>>$log_file
func_status_check $?
echo -e "\e[36m>>>>>>>>> Substituting IP <<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_status_check $?
echo -e "\e[36m>>>>>>>>> Restart Mongo Services <<<<<<<<\e[0m"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_status_check $?

