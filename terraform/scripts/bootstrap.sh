#!/bin/bash

apt -y update 
apt -y upgrade 

sudo apt -y install fontconfig openjdk-21-jre
java -version

echo "Installed Java"

echo "Installing Jenkins"
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt -y update
sudo apt -y install jenkins


echo "Jenkins Installed"

systemctl enable jenkins
