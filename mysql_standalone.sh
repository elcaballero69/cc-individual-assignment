#!/bin/bash
sudo apt-get update
yes | sudo apt-get install mysql-server
sudo apt install wget

# dowmload and unzip sakila
sudo apt-get install unzip
sudo mkdir sakila
cd sakila
sudo wget https://downloads.mysql.com/docs/sakila-db.zip
sudo unzip sakila-db.zip

# initialize mysql and add the sakila database
sudo mysql -e "UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql -e "CREATE USER 'nick'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES on sakila.* TO 'nick'@'localhost';"
sudo mysql -e "SOURCE /home/ubuntu/sakila/sakila-db/sakila-schema.sql;"
sudo mysql -e "SOURCE /home/ubuntu/sakila/sakila-db/sakila-data.sql;"

yes | sudo apt-get install sysbench
# run sysbench against standalone sakila database
# read only
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=1000 /usr/share/sysbench/oltp_read_write.lua prepare
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=1000 --num-threads=6 --max-time=60 /usr/share/sysbench/oltp_read_write.lua run
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_only.lua cleanup
# read & write
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_write.lua prepare
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_write.lua run
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_write.lua cleanup
# write only
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_write_only.lua prepare
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_write_only.lua run
sysbench --db-driver=mysql --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_write_only.lua cleanup