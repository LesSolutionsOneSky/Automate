<# 
Deploy.ps1
Automated deployment of ConnectWise Automate Agent
#>

# Variables
$DownloadUrl   = "https://raw.githubusercontent.com/LesSolutionsOneSky/Automate/main/Agent_Install.zip"   # <-- replace with your real Automate ZIP URL
$ZipPath       = "$env:TEMP\AutomateDeploy.zip"
$ExtractPath   = "$env:TEMP\AutomateDeploy"

Try {
    Write-Host "Forcing TLS 1.2..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Cleanup old files
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    if (Test-Path $ExtractPath) { Remove-Item $ExtractPath -Recurse -Force }

    # Download ZIP as binary
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath -UseBasicParsing

    # Verify file size (optional)
    Write-Host "Downloaded file size: $((Get-Item $ZipPath).Length) bytes"

    # Extract ZIP
    Write-Host "Extracting ZIP with .NET..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipPath, $ExtractPath)

    # Run the BAT inside
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
    # Keep extracted files in case you want to troubleshoot
}
