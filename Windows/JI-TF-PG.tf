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
<powershell>
Set-ExecutionPolicy -executionpolicy unrestricted 
New-Item -ItemType directory -Path C:\install_tableau
cd C:\install_tableau
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe -OutFile "Python3.9.0.exe"
Invoke-WebRequest https://downloads.tableau.com/esdalt/2020.2.3/TableauServer-64bit-2020-2-3.exe -OutFile "Tableau_Server-2020.2.3.exe"
Invoke-WebRequest https://downloads.tableau.com/esdalt/2020.2.3/TableauServerTabcmd-64bit-2020-2-3.exe -OutFile "Tableau_Server_TabCMD-2020.2.3.exe"
Invoke-WebRequest https://downloads.tableau.com/esdalt/2020.2.2/tableau_powertools/Tabcmt-32bit-2020-2-2.exe -OutFile "Tableau_Server_TabCMT-2020.2.2.exe"
Invoke-WebRequest https://raw.githubusercontent.com/tableau/server-install-script-samples/master/windows/tsm/SilentInstaller/SilentInstaller.py -OutFile "Tableau_Silent_Installer.py"
Invoke-WebRequest https://raw.githubusercontent.com/jirizarry426/Terraform-Playground/main/Windows/bootstrap.json -OutFile "bootstrap.json"
Invoke-WebRequest https://raw.githubusercontent.com/jirizarry426/Terraform-Playground/main/Windows/config.json -OutFile "config.json"
Invoke-WebRequest https://raw.githubusercontent.com/jirizarry426/Terraform-Playground/main/Windows/secrets.json -OutFile "secrets.json"
Invoke-WebRequest https://raw.githubusercontent.com/jirizarry426/Terraform-Playground/main/Windows/reg_templ.json -OutFile "reg.json"
Set-ExecutionPolicy -executionpolicy restricted 
</powershell> 
EOF

  tags = {
    Name = "tableau_server_2020.2.2"
  }

  vpc_security_group_ids = [
    "sg-c43d66a6"
  ]
}


