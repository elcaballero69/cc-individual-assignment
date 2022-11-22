sudo apt-get update
sudo apt-get install mysql-server
y| sudo apt install wget
apt-get install sysbench
y|
sudo apt-get install unzip
sudo mkdir sakila
cd sakila
sudo wget https://downloads.mysql.com/docs/sakila-db.zip
sudo unzip sakila-db.zip
sudo mysql
mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
mysql> exit
mysql -u root -p
password
mysql> SOURCE ~/sakila/sakila-db/sakila-schema.sql;
mysql> SOURCE ~/sakila/sakila-db/sakila-data.sql;




'''
mysql> create database testdb;
mysql> create user 'testuser'@'localhost' identified by 'password';
mysql> GRANT ALL PRIVILEGES ON testdb.* TO'testuser'@'localhost';
mysql> use testdb;
mysql> create table customers (customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, first_name TEXT, last_name TEXT);
mysql> SHOW COLUMNS FROM customers;
'''