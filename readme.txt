The following are the instruction to deploy Automate Agent on Workstations;

these are both Powershell functions calling the script from this repository

Screenconnect Deployment
=================
#!ps 
#timeout=900000 
#maxlength=9000000 
Invoke-Expression(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/LesSolutionsOneSky/Automate/main/Deploy.ps1')


Powershell Command
=================
Invoke-Expression(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/LesSolutionsOneSky/Automate/main/Deploy.ps1')
