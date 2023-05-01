script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh
component=catalogue
fun_nodejs


echo -e "\e[36m>>>>>>>>> Copy MongoDB repo <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>> Install MongoDB Client <<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<\e[0m"
mongo --host mongodb.swedev99.online </app/schema/catalogue.js




