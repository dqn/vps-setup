#!/bin/bash

eval "$(cat .env <(echo) <(declare -x))"

scp -P ${PORT} example.conf example.service ${USER_NAME}@${HOST}:/home/${USER_NAME}/
ssh -t ${USER_NAME}@${HOST} -p ${PORT} << EOS
sudo mv /home/${USER_NAME}/example.conf /etc/nginx/conf.d/
sudo mv /home/${USER_NAME}/example.service /etc/systemd/system/
sudo systemctl enable example.service
sudo nginx -s stop
/usr/local/certbot/certbot-auto certonly --standalone -d ${HOST} -m ${MAIL} --agree-tos -n
sudo systemctl start nginx
EOS
