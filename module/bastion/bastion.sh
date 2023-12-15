#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "${private-key}" >> /home/ubuntu/keypair
sudo chmod 400 /home/ubuntu/keypair
sudo chown ubuntu:ubuntu /home/ubuntu/keypair
sudo hostnamectl set-hostname Bastion