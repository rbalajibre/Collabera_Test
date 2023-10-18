#!/bin/bash
sudo su
yum update -y
yum install -y docker
systemctl start docker.service
systemctl enable docker.service
useradd -s /bin/bash -m -d /opt/dev dev
usermod -aG docker dev
su dev
docker pull nginxdemos/hello:latest
docker run -p 80:80 --name nginxdemo -d nginxdemos/hello