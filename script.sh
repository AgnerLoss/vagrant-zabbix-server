#!/bin/bash

#Instalação do Zabbix no ubuntu 22.04
# instalação do Mysql
echo "Instalando Mysql" 
apt update
apt install mysql-server -y
systemctl start mysql
echo "Mysql ok"

# Instalação do zabbix server e agente
apt update
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y

# Integração do zabbix e mysql
echo "Processando o Mysql"
systemctl restart mysql
mysql -uroot -e "create database agner character set utf8mb4 collate utf8mb4_bin;"
mysql -uroot -e "create user agner@localhost identified by 'Aguinho29@3';"
mysql -uroot -e "grant all privileges on agner.* to agner@localhost;"
mysql -uroot -e "set global log_bin_trust_function_creators = 1;"
echo "Integração ok"

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uagner -p"${{secrets.ZABBIX_SECRET}}" agner

mysql -uroot -e "set global log_bin_trust_function_creators = 0;"

sed 's/# DBPassword=/DBPassword=${{secrets.ZABBIX_SECRET}}/g' /etc/zabbix/zabbix_server.conf -i
sed 's/DBName=zabbix/DBName=agner/' /etc/zabbix/zabbix_server.conf -i
sed 's/DBUser=zabbix/DBUser=agner/' /etc/zabbix/zabbix_server.conf -i


systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2








