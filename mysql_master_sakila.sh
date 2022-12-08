#!/bin/bash
# dowmload and unzip sakila
sudo apt-get install unzip
sudo mkdir sakila
cd sakila
sudo wget https://downloads.mysql.com/docs/sakila-db.zip
sudo unzip sakila-db.zip

# https://fedingo.com/how-to-automate-mysql_secure_installation-script/
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';"
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('ip-172-31-46-81.ec2.internal', '127.0.0.1', '::1');"
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "DROP DATABASE IF EXISTS test;"
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "FLUSH PRIVILEGES;"
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "CREATE USER 'nick'@'ip-172-31-46-81.ec2.internal' IDENTIFIED BY 'password';"
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "GRANT ALL PRIVILEGES on sakila.* TO 'nick'@'ip-172-31-46-81.ec2.internal';"


mysql -uroot -e "UPDATE mysql.user SET Password = PASSWORD('mypassword') WHERE User = 'root'"
mysql -uroot -e "DROP USER ''@'localhost'"
mysql -uroot -e "DROP USER ''@'$(ip)'"
mysql -uroot -e "DROP DATABASE test"
mysql -uroot -e "FLUSH PRIVILEGES"
