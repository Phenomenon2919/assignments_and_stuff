#!/bin/bash

# update the lists, then make apt compatible with https sources
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# get the gpg key and add into apt
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# check if key is the right one, else exit
if [ $( sudo apt-key fingerprint 0EBFCD88 | grep "Docker Release (CE deb) <docker@docker.com>" -c ) -eq 1 ]
then
    echo "Verified!"
else
    exit 1
fi

# add the docker repo and update the package lists
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $( lsb_release -cs ) stable"
sudo apt update

# then finally install docker and supporting packages
sudo apt install docker-ce docker-ce-cli containerd.io