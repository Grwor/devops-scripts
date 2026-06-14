#!/bin/bash

apt update && apt upgrade -y
apt install -y fontconfig openjdk-21-jre

mkdir -p /opt/jenkins
cd /opt/jenkins
wget https://get.jenkins.io/war-stable/latest/jenkins.war

nohup java -jar /opt/jenkins/jenkins.war --httpPort=8080 > /tmp/jenkins.log 2>&1 &

echo "Jenkins starting on port 8080"
echo "Check logs: tail -f /tmp/jenkins.log"
