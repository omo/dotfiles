#!/bin/sh

if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
  # See https://docs.docker.com/installation/ubuntulinux/
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
  echo "deb https://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
  aptitude update
fi

# http://stackoverflow.com/questions/23169385/installing-docker-io-on-ubuntu-14-04lts
usermod -a -G docker vagrant
