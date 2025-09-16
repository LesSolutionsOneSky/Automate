<# 
Uninstall-Automate.ps1
Automates ConnectWise Automate Agent removal
#>

# Variables
$DownloadUrl   = "https://s3.amazonaws.com/assets-cp/assets/Agent_Uninstaller.zip"
$ZipPath       = "$env:TEMP\Agent_Uninstall.zip"
$ExtractPath   = "$env:TEMP\AutomateUninstall"

Try {
    Write-Host "Forcing TLS 1.2..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Cleanup old files
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    if (Test-Path $ExtractPath) { Remove-Item $ExtractPath -Recurse -Force }

    Write-Host "Downloading Automate Uninstaller ZIP..."
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath -UseBasicParsing

    Write-Host "Extracting ZIP..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipPath, $ExtractPath)

    # Run Agent_Uninstaller.exe to generate uninstall.exe
    $AgentUninstaller = Join-Path $ExtractPath "Agent_Uninstaller.exe"
    if (-not (Test-Path $AgentUninstaller)) {
        Throw "Agent_Uninstaller.exe not found in $ExtractPath"
    }

    Write-Host "Running Agent_Uninstaller.exe..."
    Start-Process -FilePath $AgentUninstaller -Wait -NoNewWindow

    # Run uninstall.exe silently
    $UninstallEXE = Join-Path $ExtractPath "uninstall.exe"
    if (-not (Test-Path $UninstallEXE)) {
        Throw "uninstall.exe not created by Agent_Uninstaller.exe"
    }

    Write-Host "Running uninstall.exe silently..."
    Start-Process -FilePath $UninstallEXE -ArgumentList "/S" -Wait -NoNewWindow

    Write-Host "Automate Agent uninstall complete."
}
Catch {
    Write-Error "Uninstall failed: $_"
}
Finally {
    # Optional cleanup
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    # You can remove $ExtractPath too, but I usually leave it for verification
}
