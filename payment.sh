script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_passwd=$1
component=payment
if [ -z "$rabbitmq_passwd" ]
then
  echo rabbitmq_passwd password missing
  exit
fi
func_python



