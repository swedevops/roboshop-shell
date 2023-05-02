app_user=roboshop
func_print_head(){
 echo -e "\e[36m>>>>>>>>> $1 <<<<<<<<\e[0m"
}
func_nodejs(){
  func_print_head " Configuring NodeJS repos "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head " Install NodeJS "
  yum install nodejs -y
   func_pre-requisites
  func_print_head " Install NodeJS Dependencies "
  npm install

  func_systemd_setup
  func_schema_setup
 }
func_schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
  echo -e "\e[36m>>>>>>>>> Copy MongoDB repo <<<<<<<<\e[0m"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[36m>>>>>>>>> Install MongoDB Client <<<<<<<<\e[0m"
  yum install mongodb-org-shell -y

  echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<\e[0m"
  mongo --host mongodb-dev.swedev99.online </app/schema/${component}.js
 fi

 if [ "$schema_setup" == "mqsql" ]; then

      func_print_head "Install MySQL"
      yum install mysql -y

      func_print_head "Load Schema"
      mysql -h mysql-dev.swedev99.online -uroot -p${mysql_root_user}</app/schema/${component}.sql
      func_systemd_setup
    fi
}

func_pre-requisites()
{
  func_print_head "Create App User"
     useradd ${app_user}
     
     func_print_head "Create App Directory"
     rm -rf /app
     mkdir /app
  
     func_print_head " Download App Content"
     curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  
      func_print_head "Extract App Content"
     cd /app
     unzip /tmp/${component}.zip

}

 func_systemd_setup(){
    func_print_head " Setup SystemD Service"
      cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

      func_print_head " Start ${component} Service"
      systemctl daemon-reload
      systemctl enable ${component}
      systemctl restart ${component}
 }
 func_java(){

   func_print_head "Install Maven"
   yum install maven -y
   func_pre-requisites
   func_print_head "Download Maven Dependencies"
         mvn clean package
         mv target/${component}-1.0.jar ${component}.jar
         func_systemd_setup
         func_schema_setup

 }




