script=$(realpath "$0")
#echo script
script_path=$(dirname "$script")
source ${script_path}/common.sh
component=user
func_schema_setup=mongo
fun_nodejs


