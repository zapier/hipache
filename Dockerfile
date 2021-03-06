# This file describes how to build hipache into a runnable linux container with all dependencies installed
# To build:
# 1) Install docker (http://docker.io)
# 2) Clone hipache repo if you haven't already: git clone https://github.com/dotcloud/hipache.git
# 3) Build: cd hipache && docker build .
# 4) Run:
# docker run -d <imageid>
# redis-cli
#
# VERSION		0.2
# DOCKER-VERSION	0.4.0

from	ubuntu:12.04
run	echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
run	apt-get -y update
run	apt-get -y install wget git redis-server supervisor
run	wget -O - http://nodejs.org/dist/v0.8.23/node-v0.8.23-linux-x64.tar.gz | tar -C /usr/local/ --strip-components=1 -zxv
run	npm install hipache -g
run	mkdir -p /var/log/supervisor
run mkdir -p /var/log/nginx 

add	./config/config_dev.json /usr/local/lib/node_modules/hipache/config/config_dev.json
add	./config/config_test.json /usr/local/lib/node_modules/hipache/config/config_test.json
add ./generate_configurations.sh /tmp/generate_configurations.sh

expose	80
expose	6379

ENV REDIS_BIND "127.0.0.1"
ENV SETTINGS_FLAVOR "dev"
ENV USE_SSL "false"

cmd	/bin/bash /tmp/generate_configurations.sh && supervisord -n
