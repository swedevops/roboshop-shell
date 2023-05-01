app_user=roboshop
print_head(){
 echo -e "\e[36m>>>>>>>>> $1 <<<<<<<<\e[0m"
}
fun_nodejs(){
  print_head " Configuring NodeJS repos "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head " Install NodeJS "
  yum install nodejs -y

  print_head " Add Application User "
  useradd ${app_user}

  print_head " Create Application Directory "
  rm -rf /app
  mkdir /app

  print_head " Download App Content "
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head " Unzip App Content "
  unzip /tmp/${component}.zip

  print_head " Install NodeJS Dependencies "
  npm install
  print_head " Create Application Directory "
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head " Start ${component} Service "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
 }




