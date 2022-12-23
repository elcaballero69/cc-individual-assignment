#!/bin/bash
# dowmload and unzip sakila
source /etc/profile.d/mysqlc.sh
wget -q https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xzf sakila-db.tar.gz
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "SOURCE /home/ubuntu/sakila-db/sakila-schema.sql;SOURCE /home/ubuntu/sakila-db/sakila-data.sql;USE sakila;SHOW FULL TABLES;"
sudo /opt/mysqlcluster/home/mysqlc/bin/mysql -e "CREATE USER 'nicj'@'localhost' IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON *.* TO 'cedric'@'localhost' WITH GRANT OPTION;CREATE USER 'cedric'@'%' IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON *.* TO 'cedric'@'%' WITH GRANT OPTION;"

# Sysbench installation and benchmarking
yes | sudo apt-get install sysbench
# Read only
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_only.lua prepare
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_only.lua run
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_only.lua cleanup
# Read and Write
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_write.lua prepare
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_write.lua run
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_read_write.lua cleanup
# Write
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_write_only.lua prepare
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_write_only.lua run
sudo sysbench --db-driver=mysql --mysql-host=ip-172-31-44-63.ec2.internal --mysql-user=nick --mysql_password=password --mysql-db=sakila --tables=8 --table-size=100000 /usr/share/sysbench/oltp_write_only.lua cleanup
