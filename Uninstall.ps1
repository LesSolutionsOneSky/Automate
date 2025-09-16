<# 
Uninstall-Automate.ps1
Automates ConnectWise Automate Agent removal
#>

$DownloadUrl   = "https://s3.amazonaws.com/assets-cp/assets/Agent_Uninstaller.zip"
$ZipPath       = "$env:TEMP\Agent_Uninstaller.zip"
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

    $AgentUninstaller = Join-Path $ExtractPath "Agent_Uninstaller.exe"
    if (-not (Test-Path $AgentUninstaller)) {
        Throw "Agent_Uninstaller.exe not found in $ExtractPath"
    }

    Write-Host "Launching Agent_Uninstaller.exe (non-blocking)..."
    Start-Process -FilePath $AgentUninstaller -WindowStyle Hidden

    # Wait until uninstall.exe is created
    Write-Host "Waiting for uninstall.exe to appear..."
    $UninstallEXE = Join-Path $ExtractPath "uninstall.exe"
    $timeout = (Get-Date).AddMinutes(2)

    while (-not (Test-Path $UninstallEXE)) {
        Start-Sleep -Seconds 2
        if ((Get-Date) -gt $timeout) {
            Throw "Timed out waiting for uninstall.exe to be created."
        }
    }

    Write-Host "Running uninstall.exe silently..."
    Start-Process -FilePath $UninstallEXE -ArgumentList "/S" -Wait -NoNewWindow

    # Verify Automate service is gone
    Start-Sleep -Seconds 5
    $Service = Get-Service -Name "LTService" -ErrorAction SilentlyContinue
    if ($Service) {
        Write-Warning "Uninstaller ran but LTService still exists: $($Service.Status)"
    } else {
        Write-Host "Automate Agent successfully uninstalled."
    }
}
Catch {
    Write-Error "Uninstall failed: $_"
}
Finally {
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    # keep ExtractPath for logs/debugging
}
