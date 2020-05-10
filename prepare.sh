#!/bin/bash

eval "$(cat .env <(echo) <(declare -x))"

KEY=`cat ~/.ssh/id_rsa.pub`

ssh -t root@${HOST} << EOS
#!/bin/bash

dnf -y update

# sshd
sed /etc/ssh/sshd_config -i \
  -e "s/#Port 22/Port ${SSH_PORT}/g" \
  -e "s/PermitRootLogin yes/PermitRootLogin no/g" \
  -e "s/PasswordAuthentication yes/PasswordAuthentication no/g" \
  -e "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/g"
systemctl restart sshd

# Firewall
systemctl enable firewalld
systemctl restart firewalld
firewall-cmd --add-port=${SSH_PORT}/tcp --permanent
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload

# SELinux
dnf -y install policycoreutils-python-utils
semanage port -a -t ssh_port_t -p tcp ${SSH_PORT}

# nginx
dnf -y install nginx
systemctl enable nginx
systemctl restart nginx

# certbot
cd /usr/local
git clone https://github.com/certbot/certbot
(crontab -l; echo "0 4 1 * * /usr/local/certbot/certbot-auto renew && sudo /usr/bin/systemctl reload nginx > /dev/null 2>&1") | crontab -

# create user
useradd ${USER_NAME}
echo ${USER_PASSWORD} | passwd ${USER_NAME} --stdin
usermod -G wheel ${USER_NAME}

# add public RSA key
su - ${USER_NAME}
mkdir .ssh
chmod 700 .ssh
echo ${KEY} >> .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
EOS
