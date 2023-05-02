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
component=shipping
schema_setup=mysql
func_java