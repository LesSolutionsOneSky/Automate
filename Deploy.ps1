<# 
Deploy.ps1
Automated deployment of ConnectWise Automate Agent
#>

# Variables
$DownloadUrl   = "https://onesky.hostedrmm.com/LabTech/Deployment.aspx?InstallerToken=80010c7ce06e4584b5bf75fc88e1fbd2"   # <-- replace with your real Automate ZIP URL
$ZipPath       = "$env:TEMP\AutomateDeploy.zip"
$ExtractPath   = "$env:TEMP\AutomateDeploy"

Try {
    Write-Host "Forcing TLS 1.2..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Cleanup old files
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    if (Test-Path $ExtractPath) { Remove-Item $ExtractPath -Recurse -Force }

    Write-Host "Downloading Automate ZIP..."
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath -UseBasicParsing

    Write-Host "Extracting ZIP..."
    Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force

    Write-Host "Looking for batch file..."
    $BatFile = Get-ChildItem -Path $ExtractPath -Filter *.bat | Select-Object -First 1

    if (-not $BatFile) {
        Throw "No .bat file found in $ExtractPath"
    }

    Write-Host "Running installer batch: $($BatFile.FullName)"
    Start-Process -FilePath $BatFile.FullName -Wait -NoNewWindow

    # Verify installation
    Start-Sleep -Seconds 10
    $Service = Get-Service -Name "LTService" -ErrorAction SilentlyContinue
    if ($Service) {
        Write-Host "Automate Agent installed successfully. Service: $($Service.Status)"
    } else {
        Write-Warning "Automate Agent batch executed but no service detected. Check logs."
    }
}
Catch {
    Write-Error "Deployment failed: $_"
}
Finally {
    # Optional cleanup
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    # keep extracted files in case you want to troubleshoot
}
