The following are the instruction to deploy Automate Agent on Workstations;

these are both Powershell functions calling the script from this repository

Screenconnect Deployment
=================
#!ps 
#timeout=900000 
#maxlength=9000000 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-Expression(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/LesSolutionsOneSky/Automate/main/Deploy.ps1')


Powershell Command
=================
Invoke-Expression(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/LesSolutionsOneSky/Automate/main/Deploy.ps1')

Linux Install
=================

wget -O agent.zip "https://github.com/LesSolutionsOneSky/Automate/raw/85fad46247de47ead253e91d64d6946a769e6328/LTechAgent_x86_64.zip"
          ------
            or
          ------
curl -L -o agent.zip "https://github.com/LesSolutionsOneSky/Automate/raw/85fad46247de47ead253e91d64d6946a769e6328/LTechAgent_x86_64.zip"


unzip ./agent.zip

cd LTechAgent

chmod +x install.sh

./install.sh

ps -ax | grep ltech

service ltechagent status

service ltechagent start

service ltechagent enable
