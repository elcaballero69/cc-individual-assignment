#!/bin/bash
sudo apt-get update
yes | sudo apt-get upgrade

# Install MySQL cluster
sudo mkdir -p /opt/mysqlcluster/home
sudo chmod -R 777 /opt/mysqlcluster
cd /opt/mysqlcluster/home
wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64.tar.gz
tar -zxf mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64.tar.gz
ln -s mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64 mysqlc
sudo chmod -R 777 /etc/profile.d

# add MySQL PATH varibles
echo "export MYSQLC_HOME=/opt/mysqlcluster/home/mysqlc" > /etc/profile.d/mysqlc.sh
echo "export PATH=$MYSQLC_HOME/bin:$PATH" >> /etc/profile.d/mysqlc.sh
source /etc/profile.d/mysqlc.sh
sudo apt-get update && sudo apt-get -y install libncurses5

# create directories for further use
sudo mkdir -p /opt/mysqlcluster/deploy
cd /opt/mysqlcluster/deploy
sudo mkdir conf
sudo mkdir mysqld_data
sudo mkdir ndb_data
cd conf
sudo chmod -R 777 /opt/mysqlcluster/deploy


# provide my.cnf with proper information
sudo cat <<EOF >my.cnf
[mysqld]
ndbcluster
datadir=/opt/mysqlcluster/deploy/mysqld_data
basedir=/opt/mysqlcluster/home/mysqlc
port=3306
EOF

# provide config.ini with current setup & replace the IP addresses with the prevalent form
sudo cat <<EOF >config.ini
[ndb_mgmd]
hostname=ip-172-31-46-81.ec2.internal
datadir=/opt/mysqlcluster/deploy/ndb_data
nodeid=1
[ndbd default]
noofreplicas=1
datadir=/opt/mysqlcluster/deploy/ndb_data
[ndbd]
hostname=ip-172-31-40-198.ec2.internal
nodeid=3
serverport=50501
[ndbd]
hostname=ip-172-31-42-122.ec2.internal
nodeid=4
serverport=50502
[ndbd]
hostname=ip-172-31-45-133.ec2.internal
nodeid=5
serverport=50503
[mysqld]
nodeid=50
EOF

# Initialize management node
cd /opt/mysqlcluster/home/mysqlc
scripts/mysql_install_db --no-defaults --datadir=/opt/mysqlcluster/deploy/mysqld_data

# Start managent node
sudo /opt/mysqlcluster/home/mysqlc/bin/ndb_mgmd  -f /opt/mysqlcluster/deploy/conf/config.ini --initial --configdir=/opt/mysqlcluster/deploy/conf/



