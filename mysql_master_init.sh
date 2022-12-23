#!/bin/bash
sudo apt-get update
yes | sudo apt-get upgrade

# Install MySQL cluster
sudo mkdir -p /opt/mysqlcluster/home
sudo chmod -R 777 /opt/mysqlcluster
sudo chmod -R 777 /opt/mysqlcluster/home
cd /opt/mysqlcluster/home
wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64.tar.gz
tar -zxf mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64.tar.gz
ln -s mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64 mysqlc
sudo chmod -R 777 /opt/mysqlcluster/home/mysqlc

# add MySQL PATH varibles
sudo chmod -R 777 /etc/profile.d
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
sudo chmod -R 777 /opt/mysqlcluster/deploy/conf
sudo chmod -R 777 /opt/mysqlcluster/deploy/mysql_data
sudo chmod -R 777 /opt/mysqlcluster/deploy/ndb_data


# provide my.cnf with proper information
sudo cat <<EOF >my.cnf
[mysqld]
ndbcluster
datadir=/opt/mysqlcluster/deploy/mysqld_data
basedir=/opt/mysqlcluster/home/mysqlc
bind-address=0.0.0.0
port=3306
EOF
sudo chmod 644 /opt/mysqlcluster/deploy/conf/my.cnf

# provide config.ini with current setup & replace the IP addresses with the prevalent form
sudo cat <<EOF >config.ini
[ndb_mgmd]
hostname=ip-172-31-44-63.ec2.internal
datadir=/opt/mysqlcluster/deploy/ndb_data
nodeid=1
[ndbd default]
noofreplicas=1
datadir=/opt/mysqlcluster/deploy/ndb_data
[ndbd]
hostname=ip-172-31-35-212.ec2.internal
nodeid=3
serverport=50501
[ndbd]
hostname=ip-172-31-38-186.ec2.internal
nodeid=4
serverport=50502
[ndbd]
hostname=ip-172-31-41-117.ec2.internal
nodeid=5
serverport=50503
[mysqld]
nodeid=50
EOF


# Initialize management node
cd /opt/mysqlcluster/home/mysqlc
scripts/mysql_install_db --no-defaults --datadir=/opt/mysqlcluster/deploy/mysqld_data
sudo chmod -R 777 /opt/mysqlcluster/deploy/conf/
# Start managent node
sudo /opt/mysqlcluster/home/mysqlc/bin/ndb_mgmd  -f /opt/mysqlcluster/deploy/conf/config.ini --initial --configdir=/opt/mysqlcluster/deploy/conf/

# showing the status of the slaves
sudo /opt/mysqlcluster/home/mysqlc/bin/ndb_mgm -e show


