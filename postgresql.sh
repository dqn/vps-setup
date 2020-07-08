#!/bin/bash

sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf -qy module disable postgresql
sudo dnf -y install postgresql12 postgresql12-server
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
sudo systemctl enable --now postgresql-12
su
su - postgres
psql -c "alter role postgres with password 'postgres'"
# vi /var/lib/pgsql/12/data/pg_hba.conf
