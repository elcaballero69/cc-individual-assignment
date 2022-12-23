#!/bin/bash
# General
sudo apt-get update
yes | sudo apt-get upgrade

# Install the MySQL server
sudo mkdir -p /opt/mysqlcluster/home
sudo chmod -R 777 /opt/mysqlcluster
sudo wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64.tar.gz -P /opt/mysqlcluster/home/
sudo tar -xvf /opt/mysqlcluster/home/mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64.tar.gz -C /opt/mysqlcluster/home/
sudo ln -s /opt/mysqlcluster/home/mysql-cluster-gpl-7.4.10-linux-glibc2.5-x86_64 /opt/mysqlcluster/home/mysqlc


# Add MySQL path variable
sudo chmod -R 777 /etc/profile.d
echo "export MYSQLC_HOME=/opt/mysqlcluster/home/mysqlc" > /etc/profile.d/mysqlc.sh
echo "export PATH=$MYSQLC_HOME/bin:$PATH" >> /etc/profile.d/mysqlc.sh
source /etc/profile.d/mysqlc.sh
sudo apt-get update && sudo apt-get -y install libncurses5

# Install sysbench
yes | sudo apt-get install sysbench
mkdir -p /opt/mysqlcluster/deploy/ndb_data
sudo /opt/mysqlcluster/home/mysqlc/bin/ndbd -c ip-172-31-44-63.ec2.internal