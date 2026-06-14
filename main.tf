provider "aws" {
  region = "eu-north-1"
}

# Jenkins Master + Apache
resource "aws_instance" "jenkins_master" {
  ami           = "ami-09a9858973b288bdd"
  instance_type = "t3.small"
  key_name      = "new"

  vpc_security_group_ids = [aws_security_group.main_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update && apt upgrade -y
    apt install -y fontconfig openjdk-21-jre apache2
    systemctl enable apache2 && systemctl start apache2
    mkdir -p /opt/jenkins
    wget -q https://get.jenkins.io/war-stable/latest/jenkins.war -O /opt/jenkins/jenkins.war
    nohup java -jar /opt/jenkins/jenkins.war --httpPort=8080 > /tmp/jenkins.log 2>&1 &
  EOF

  tags = {
    Name = "jenkins-master"
  }
}

# Jenkins Slave
resource "aws_instance" "jenkins_slave" {
  ami           = "ami-09a9858973b288bdd"
  instance_type = "t3.micro"
  key_name      = "new"

  vpc_security_group_ids = [aws_security_group.main_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update && apt upgrade -y
    apt install -y fontconfig openjdk-21-jre
  EOF

  tags = {
    Name = "jenkins-slave"
  }
}

# Web Server + WildFly
resource "aws_instance" "web_server" {
  ami           = "ami-09a9858973b288bdd"
  instance_type = "t3.micro"
  key_name      = "new"

  vpc_security_group_ids = [aws_security_group.main_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update && apt upgrade -y
    apt install -y openjdk-11-jdk apache2
    systemctl enable apache2 && systemctl start apache2
    wget -q https://github.com/wildfly/wildfly/releases/download/30.0.0.Final/wildfly-30.0.0.Final.tar.gz
    tar xf wildfly-30.0.0.Final.tar.gz
    mv wildfly-30.0.0.Final /opt/wildfly
    groupadd wildfly
    useradd -g wildfly wildfly
    chown -R wildfly:wildfly /opt/wildfly
  EOF

  tags = {
    Name = "web-server"
  }
}

# Security Group
resource "aws_security_group" "main_sg" {
  name = "terraform-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-sg"
  }
}

output "jenkins_master_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_slave_ip" {
  value = aws_instance.jenkins_slave.public_ip
}

output "web_server_ip" {
  value = aws_instance.web_server.public_ip
}
