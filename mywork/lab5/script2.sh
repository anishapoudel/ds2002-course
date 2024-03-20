#!/bin/bash

apt update -y
apt upgrade -y 

apt install -y docker.io awscli redis-server

systemctl start docker
systemctl enable docker
systemctl start redis-server
systemctl enable redis-server
