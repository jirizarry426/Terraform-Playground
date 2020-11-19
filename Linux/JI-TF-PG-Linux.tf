provider "aws" {
  region  = "us-east-2"
  profile = "default"
}

data "aws_ami" "ec2" {
  most_recent = "true"
  owners      = ["801119661308"]

  filter {
    name   = "name"
    values = ["*Windows_Server-2019-English-Full-Base-2020.09.09*"]

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
wget https://github.com/tableau/server-install-script-samples/raw/master/linux/automated-installer/packages/tableau-server-automated-installer-2019-1.noarch.rpm
automated-installer -s tab-tf-linux -f tabtf-linux-config.json -r tabtf-linux-reg.json --accepteula [optional arguments] package-file
EOF

  tags = {
    Name = "tableau_server_2020.2.2"
  }

  vpc_security_group_ids = [
    "sg-c43d66a6"
  ]
}


