script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_passwd=$1

if [ -z "$rabbitmq_passwd" ]
then
  echo input password missing
  exit
  fi
func_print_head " Download App Content - setup erland repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_status_check $?
func_print_head " Install erlang "
yum install erlang -y &>>$log_file
func_status_check $?
func_print_head " Download App Content - setup rabbitmq repos "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_status_check $?
func_print_head "  Install rabbitmq  "
yum install rabbitmq-server -y &>>$log_file
func_status_check $?
func_print_head " Start rabbitmq Service "
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
func_status_check $?
func_print_head "Add application user  "
rabbitmqctl add_user roboshop ${rabbitmq_passwd} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_status_check $?


