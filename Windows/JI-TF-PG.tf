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
  instance_type = "t2.xlarge"
  key_name      = "tftableau"
  user_data     = <<EOF
<powershell>
Set-ExecutionPolicy -executionpolicy unrestricted
$TABLEAUTFTMP = ?pt9*$DRz9x3d=+kbjM&!Xb?G
New-LocalUser "tableautf" -Password $TABLEAUTFTMP -FullName "tableautf" -Description "To Run Tableau Silent Installer; To be deleted after completetion"
Add-LocalGroupmember -Group "Administrators" -Member "tableautf" 
New-Item -ItemType directory -Path C:\install_tableau
cd C:\install_tableau
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest https://raw.githubusercontent.com/tableau/server-install-script-samples/master/windows/tsm/SilentInstaller/SilentInstaller.py -OutFile "Tableau_Silent_Installer.py"
Invoke-WebRequest https://raw.githubusercontent.com/jirizarry426/Terraform-Playground/main/Windows/bootstrap.json -OutFile "bootstrap.json"
Invoke-WebRequest https://raw.githubusercontent.com/jirizarry426/Terraform-Playground/main/Windows/config.json -OutFile "config.json"
Invoke-WebRequest https://raw.githubusercontent.com/jirizarry426/Terraform-Playground/main/Windows/secrets.json -OutFile "secrets.json"
Invoke-WebRequest https://raw.githubusercontent.com/jirizarry426/Terraform-Playground/main/Windows/reg.json -OutFile "reg.json"
Invoke-WebRequest https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe -OutFile "python-3.9.0.exe"
.\python-3.9.0.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
Invoke-WebRequest https://downloads.tableau.com/esdalt/2020.3.3/TableauServer-64bit-2020-3-3.exe -OutFile "Tableau_Server-2020.3.3_20203.20.1110.1623.exe"
Invoke-WebRequest https://downloads.tableau.com/esdalt/2020.3.3/TableauServerTabcmd-64bit-2020-3-3.exe -OutFile "TabCMD-2020.3.3_20203.20.1110.1623.exe"
Invoke-WebRequest https://downloads.tableau.com/esdalt/2020.3.0/tableau_powertools/Tabcmt-32bit-2020-3-0.exe -OutFile "TabCMT-2020.3.0_20203.20.0807.2057.exe"
.\Tableau_Silent_Installer.py --bootstrapFile bootstrap.json
tsm security external-ssl enable --cert-file CertFile.crt --key-file KeyFile.key --chain-File ChainFile.crt
tsm restart
.\TabCMT-2020.3.0_20203.20.0807.2057.exe /install /quiet /norestart
.\TabCMD-2020.3.3_20203.20.1110.1623.exe /install /quiet /norestart ACCEPTEULA=1 INSTALLDIR=<PATH-TO-Directory>
cd ..
cd '.\Program Files (x86)\Tableau\Tableau Content Migration Tool\'
tabcmt-runner encryption <encryption key>
Remove-LocalUser -Name "tableautf"
Set-ExecutionPolicy -executionpolicy restricted 
</powershell> 
EOF

  tags = {
    Name = "tableau_server_2020.3.3"
  }

  vpc_security_group_ids = [
    "sg-c43d66a6"
  ]
  root_block_device {
    volume_size = 300
  }

}




