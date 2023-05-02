script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_passwd=$1

if [ -z "$rabbitmq_passwd" ]
then
  echo input missing
  exit
  fi
 echo -e "\e[36m>>>>>>>>> Setup ErLang Repos <<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Setup RabbitMQ Repos <<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Install ErLang & RabbitMQ <<<<<<<<\e[0m"
yum install erlang rabbitmq-server -y &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Start RabbitMQ Service <<<<<<<<\e[0m"
systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
func_status_check $?

echo -e "\e[36m>>>>>>>>> Add Application User in RabbtiMQ <<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_passwd} &>>$log_file
func_status_check $?
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_status_check $?


