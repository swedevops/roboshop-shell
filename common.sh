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
  curl -o /tmp/${function}.zip https://roboshop-artifacts.s3.amazonaws.com/${function}.zip
  cd /app

  print_head " Unzip App Content "
  unzip /tmp/${function}.zip

  print_head " Install NodeJS Dependencies "
  npm install
  print_head " Create Application Directory "
  cp ${script_path}/${function}.service /etc/systemd/system/${function}.service

  print_head " Start ${function} Service "
  systemctl daemon-reload
  systemctl enable ${function}
  systemctl restart ${function}
}




