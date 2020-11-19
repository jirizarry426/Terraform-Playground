provider "aws" {
  region  = "us-east-2"
  profile = "default"
}

data "aws_ami" "ec2" {
  most_recent = "true"
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["*amzn2-ami-hvm-2.0.20200917.0-x86_64-gp2*"]

  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }
}

resource "aws_instance" "tableau" {
  ami           = data.aws_ami.ec2.id
  instance_type = "t2.micro"
  key_name      = "tftableau"
  user_data     = <<EOF
#!/bin/bash
yum update -y
yum install wget
wget https://downloads.tableau.com/esdalt/2020.3.1/tableau-server-2020-3-1.x86_64.rpm
wget https://downloads.tableau.com/esdalt/2020.3.1/tableau-tabcmd-2020-3-1.noarch.rpm
wget https://github.com/tableau/server-install-script-samples/blob/master/linux/automated-installer/packages/tableau-server-automated-installer-2019-1.noarch.rpm?raw=true
wget https://raw.githubusercontent.com/jirizarry426/terraform-playground/master/Linux/secrets
wget https://raw.githubusercontent.com/jirizarry426/terraform-playground/master/Linux/reg_templ.json
wget https://raw.githubusercontent.com/jirizarry426/terraform-playground/master/Linux/config.json
automated-installer -s secrets -f config.json -r reg_templ.json --accepteula yes package-file tableau-server-2020-3-1.x86_64.rpm --debug
EOF

  tags = {
    Name = "tableau_server_2020.3.1"
  }

  vpc_security_group_ids = [
    "sg-c43d66a6"
  ]
}


