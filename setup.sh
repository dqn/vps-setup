#!/bin/bash

eval "$(cat .env <(echo) <(declare -x))"

KEY=`cat ~/.ssh/id_rsa.pub`

ssh -t root@${HOST} << EOS
sed -i \
  -e "s/#Port 22/Port ${PORT}/g" \
  -e "s/PermitRootLogin yes/PermitRootLogin no/g" \
  -e "s/PasswordAuthentication yes/PasswordAuthentication no/g" \
  -e "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/g" \
  /etc/ssh/sshd_config
systemctl restart sshd
useradd ${USER_NAME}
echo ${USER_PASSWORD} | passwd ${USER_NAME} --stdin
usermod -G wheel ${USER_NAME}
su - ${USER_NAME}
mkdir .ssh
chmod 700 .ssh
echo ${KEY} >> .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
EOS
