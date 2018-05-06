#!/bin/bash


#Setup Hosts for user Update
for REMOTE_IP in \
 10.228.82.219 \
 10.228.4.176  \
 10.228.12.102 \
 10.228.71.203 \
 10.228.134.205 \
 10.228.136.62 \
 10.228.133.89 \
 10.228.11.94  \
 10.228.150.243 \
 10.228.68.191 \
 10.228.74.174 \
 10.228.129.23 \
 10.228.130.60 \
 10.228.148.204 \
 10.228.17.161 \
 10.228.154.57 \
 10.228.67.186 \
 10.228.14.45  \
 10.228.12.197 \
 10.228.154.189 \
 10.228.147.110

 do

	#Transfer over create user file
	expect -c "
	   set timeout 1
	   spawn scp /Users/robjacks/Documents/workspaces/aws_configuration/nonprod-server-configs/users/create_users.sh  rjackson@$REMOTE_IP:/home/rjackson
	   expect yes/no { send yes\r ; exp_continue }
	   sleep 5
	   exit
	"
	#Excecute copmmands to run user script
	ssh rjackson@$REMOTE_IP 'sudo cp create_users.sh /data/create_users.sh 2>&1' >> /Users/robjacks/Documents/data/logs/creat_users.log
	ssh rjackson@$REMOTE_IP 'sudo /data//create_users.sh 2>&1' >> /Users/robjacks/Documents/data/logs/creat_users.log

	sleep 60

done