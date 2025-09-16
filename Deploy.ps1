$DownloadUrl = "https://onesky.hostedrmm.com/LabTech/Deployment.aspx?InstallerToken=80010c7ce06e4584b5bf75fc88e1fbd2"
$InstallerPath = "$env:TEMP\AutomateAgent.msi"

Try {
    Write-Host "Downloading Automate Agent..."
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath -UseBasicParsing

    Write-Host "Installing Automate Agent..."
    Start-Process "msiexec.exe" -ArgumentList "/i `"$InstallerPath`" /quiet /norestart" -Wait -NoNewWindow

    Write-Host "Automate Agent installation complete."
}
Catch {
    Write-Error "Installation failed: $_"
}
Finally {
    # Optional: cleanup
    if (Test-Path $InstallerPath) { Remove-Item $InstallerPath -Force }
}
