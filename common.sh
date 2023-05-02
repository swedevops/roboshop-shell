app_user=roboshop
log_file=/tmp/roboshop.log
func_print_head(){
 echo -e "\e[36m>>>>>>>>> $1 <<<<<<<<\e[0m"
}
func_nodejs(){
  func_print_head " Configuring NodeJS repos "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_status_check $?
   func_print_head " Install NodeJS "
  yum install nodejs -y &>>$log_file
  func_status_check $?
   func_pre-requisites
  func_print_head " Install NodeJS Dependencies "
  npm install &>>$log_file
  func_status_check $?

  func_systemd_setup
  func_schema_setup
 }
 func_status_check(){
   if [ $1 -eq 0 ]; then
     echo -e "\e[32m sucess \e[0m"
     else
       echo -e "\e[31m failure \e[0m"
       echo refer the log
       exit 1
       fi
 }
func_schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
  echo -e "\e[36m>>>>>>>>> Copy MongoDB repo <<<<<<<<\e[0m"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
  func_status_check $?

  echo -e "\e[36m>>>>>>>>> Install MongoDB Client <<<<<<<<\e[0m"
  yum install mongodb-org-shell -y &>>$log_file
  func_status_check $?

  echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<\e[0m"
  mongo --host mongodb-dev.swedev99.online </app/schema/${component}.js &>>$log_file
  func_status_check $?
 fi

 if [ "$schema_setup" == "mysql" ]; then

      func_print_head "Install MySQL"
      yum install mysql -y &>>$log_file
      func_status_check $?

      func_print_head "Load Schema"
      mysql -h mysql-dev.swedev99.online -uroot -p${mysql_root_user}</app/schema/${component}.sql
      func_systemd_setup
    fi
}

func_pre-requisites()
{
  func_print_head "Create App User"
     useradd ${app_user} &>/tmp/roboshop.log &>>$log_file
     func_status_check $?
     
     func_print_head "Create App Directory"
     rm -rf /app
     mkdir /app &>>$log_file
     func_status_check $?
     func_print_head " Download App Content"
     curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
      func_status_check $?
      func_print_head "Extract App Content"
     cd /app
     unzip /tmp/${component}.zip &>>$log_file
     func_status_check $?

}

 func_systemd_setup(){
    func_print_head " Setup SystemD Service"
      cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
      func_status_check $?
      func_print_head " Start ${component} Service"
      systemctl daemon-reload
      systemctl enable ${component}
      systemctl restart ${component} &>>$log_file
      func_status_check $?
 }
 func_java(){

   func_print_head "Install Maven"
   yum install maven -y &>>$log_file
   func_status_check $?
   func_pre-requisites
   func_print_head "Download Maven Dependencies"
         mvn clean package &>>$log_file
         func_status_check $?
         mv target/${component}-1.0.jar ${component}.jar &>>$log_file
         func_status_check $?
         func_systemd_setup
         func_schema_setup

 }

func_python()
{
  echo -e "\e[36m>>>>>>>>> Install Python <<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>$log_file
  func_status_check $?
  func_pre-requisites

  echo -e "\e[36m>>>>>>>>> Install Dependencies <<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>$log_file
  func_status_check $?

  echo -e "\e[36m>>>>>>>>>Setup SystemD Service <<<<<<<<\e[0m"
  sed -i -r "s|rabbitmq_passwd|${rabbitmq_passwd}|" ${script_path}/payment.service &>>$log_file
  func_status_check $?
  func_systemd_setup
}


