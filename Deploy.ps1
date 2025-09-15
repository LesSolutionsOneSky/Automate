$DirectoryToCreate = "C:\temp"

<# install Net Frame 4.8#>
$DownloadNET = "https://github.com/LesSolutionOneSky/Automate/raw/main/dotNetFx35setup.exe"
$SoftwareNETPath = "C:\Temp\Netframe.exe"
if (-not (Test-Path -LiteralPath $DirectoryToCreate)) {
    mkdir "C:\temp"
} Try {
    Write-Host "Downloading from: $($DownloadNET)"
    Write-Host "Downloading to:   $($SoftwareNETPath)"
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadNET, $SoftwareNETPath)
    Write-Host "Download Complete"
$process = (Start-Process -FilePath $SoftwareNETPath -ArgumentList "/q /norestart" -Wait -Verb RunAs -PassThru)
Write-Host -Fore Red "Errorcode: " $process.ExitCode
} catch {
    Write-Host "Error in creating temp Folder! Error: " $process.ExitCode
    }
<# End of NetFrame Work Install #>

<# Install Automate#>
$DownloadPath = "https://github.com/LesSolutionOneSky/Automate/raw/main/Agent_Install.msi"
$SoftwarePath = "C:\Temp\Automate_Agent.msi"

    Write-Host "Downloading from: $($DownloadPath)"
    Write-Host "Downloading to:   $($SoftwarePath)"
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($DownloadPath, $SoftwarePath)
    Write-Host "Download Complete"

Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$SoftwarePath`" /quiet /norestart" -Wait -Verb RunAs -PassThru

