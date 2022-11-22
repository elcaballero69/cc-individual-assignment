sudo apt-get update
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster-community-management-server_8.0.31-1ubuntu20.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_8.0.31-1ubuntu20.04_amd64.deb
sudo mkdir /var/lib/mysql-cluster
nano /var/lib/mysql-cluster/config.ini

'''
[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=2	# Number of replicas

[ndb_mgmd]
# Management process options:
hostname=192.168.10.10 # Hostname of the manager
datadir=/var/lib/mysql-cluster 	# Directory for the log files

[ndbd]
hostname=192.168.10.11 # Hostname/IP of the first data node
NodeId=2			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[ndbd]
hostname=192.168.10.12 # Hostname/IP of the second data node
NodeId=3			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[mysqld]
# SQL node options:
hostname=192.168.10.10 # In our case the MySQL server/client is on the same Droplet as the cluster manager
'''

sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini
sudo pkill -f ndb_mgmd
sudo nano /etc/systemd/system/ndb_mgmd.service
'''
[Unit]
Description=MySQL NDB Cluster Management Server
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
'''

sudo systemctl daemon-reload