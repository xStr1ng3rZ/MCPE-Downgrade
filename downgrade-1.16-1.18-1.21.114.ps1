if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Host "==========================================================================" -ForegroundColor Red
    Write-Host " [INCXGNITE DOWNGRADE] Requires Administrator permissions." -ForegroundColor Red
    Write-Host " Please run PowerShell as Administrator to continue." -ForegroundColor Yellow
    Write-Host "==========================================================================" -ForegroundColor Red
    Start-Sleep -Seconds 5
    Exit
}

$ProgressPreference = 'SilentlyContinue'
$InformationPreference = 'Continue'

$116Url = 'https://github.com/Mineage-Network/mv-fixed-appx/releases/download/1.0.1/1.16.100.4.appx'
$118Url = 'https://github.com/Mineage-Network/mv-fixed-appx/releases/download/1.0.1/1.18.12.1.appx'
$121Url = 'https://github.com/Incxgnite/1.21.114/releases/download/v1.21.114/Minecraft.1.21.114.64.bits.-.By.Incxgnite.Appx'

Clear-Host
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "                       INCXGNITE DOWNGRADE VERSION                        " -ForegroundColor Yellow
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Information "Tool to change versions of Minecraft UWP (Fix Xbox Auth)"
Write-Warning "This script will replace your current Minecraft installation."

$choice = (Read-Host -Prompt 'Enter 1 to continue, or any other key to exit').Trim()
if ($choice -ne '1') {
    Write-Information "Exiting Incxgnite Downgrade..."
    Start-Sleep -Seconds 2
    Exit
}

Write-Information "[INCXGNITE] Checking Minecraft process..."
$mcProcess = Get-Process Minecraft.Windows -ErrorAction SilentlyContinue
if ($mcProcess) {
    Write-Information "[INCXGNITE] Closing Minecraft..."
    Stop-Process -Id $mcProcess.Id -Force
    Start-Sleep -Seconds 1
} else {
    Write-Information "[INCXGNITE] Minecraft is not running."
}

$choiceVersion = (Read-Host -Prompt 'Enter 1 for 1.16.100.4, Enter 2 for 1.18.12.1, Enter 3 for 1.21.114').Trim()

$mvFixedAppxPath = Join-Path -Path $env:TEMP -ChildPath "incxgnite-downgrade-temp"
if (Test-Path $mvFixedAppxPath) {
    Set-Location 'C:\'
    Remove-Item -Path $mvFixedAppxPath -Recurse -Force
}

New-Item -ItemType Directory -Path $mvFixedAppxPath -Force | Out-Null
Set-Location $mvFixedAppxPath
New-Item -ItemType Directory -Path "$mvFixedAppxPath\oldData" -Force | Out-Null

Write-Information "[INCXGNITE] Downloading required files..."

switch ($choiceVersion) {
    '1' {
        $cerPath = "$mvFixedAppxPath\1.16.100.4.cer"
        $pfxPath = "$mvFixedAppxPath\1.16.100.4.pfx"
        $appxPath = "$mvFixedAppxPath\1.16.100.4.appx"
        
        curl.exe -L -k -s "https://raw.githubusercontent.com/Mineage-Network/mv-fixed-appx/master/1.16.100.4/1.16.100.4.cer" -o $cerPath
        curl.exe -L -k -s "https://raw.githubusercontent.com/Mineage-Network/mv-fixed-appx/master/1.16.100.4/1.16.100.4.pfx" -o $pfxPath
        
        if (Get-Command aria2c -ErrorAction SilentlyContinue) {
            aria2c.exe -q -x 16 -s 16 -k 1M $116Url -o "1.16.100.4.appx" -d $mvFixedAppxPath --allow-overwrite=true | Out-Null
        } else {
            curl.exe -L -k -s $116Url -o $appxPath
        }
        
        Write-Information "[INCXGNITE] Importing certificates..."
        Import-Certificate -FilePath $cerPath -CertStoreLocation 'Cert:\LocalMachine\Root' | Out-Null
        Import-PfxCertificate -FilePath $pfxPath -CertStoreLocation 'Cert:\LocalMachine\My' | Out-Null
        Write-Information "[INCXGNITE] Version 1.16.100.4 download completed."
    }
    '2' {
        $cerPath = "$mvFixedAppxPath\1.18.12.1.cer"
        $pfxPath = "$mvFixedAppxPath\1.18.12.1.pfx"
        $appxPath = "$mvFixedAppxPath\1.18.12.1.appx"
        
        curl.exe -L -k -s "https://raw.githubusercontent.com/Mineage-Network/mv-fixed-appx/master/1.18.12.1/1.18.12.1.cer" -o $cerPath
        curl.exe -L -k -s "https://raw.githubusercontent.com/Mineage-Network/mv-fixed-appx/master/1.18.12.1/1.18.12.1.pfx" -o $pfxPath
        
        if (Get-Command aria2c -ErrorAction SilentlyContinue) {
            aria2c.exe -q -x 16 -s 16 -k 1M $118Url -o "1.18.12.1.appx" -d $mvFixedAppxPath --allow-overwrite=true | Out-Null
        } else {
            curl.exe -L -k -s $118Url -o $appxPath
        }
        
        Write-Information "[INCXGNITE] Importing certificates..."
        Import-Certificate -FilePath $cerPath -CertStoreLocation 'Cert:\LocalMachine\Root' | Out-Null
        Import-PfxCertificate -FilePath $pfxPath -CertStoreLocation 'Cert:\LocalMachine\My' | Out-Null
        Write-Information "[INCXGNITE] Version 1.18.12.1 download completed."
    }
    '3' {
        $appxPath = "$mvFixedAppxPath\1.21.114.appx"
        
        if (Get-Command aria2c -ErrorAction SilentlyContinue) {
            aria2c.exe -q -x 16 -s 16 -k 1M $121Url -o "1.21.114.appx" -d $mvFixedAppxPath --allow-overwrite=true | Out-Null
        } else {
            curl.exe -L -k -s $121Url -o $appxPath
        }
        
        Write-Information "[INCXGNITE] Version 1.21.114 download completed."
    }
    Default {
        Write-Error "[INCXGNITE] Invalid option selected: '$choiceVersion'"
        Set-Location 'C:\'
        Remove-Item -Path $mvFixedAppxPath -Recurse -Force
        Start-Sleep -Seconds 3
        Exit
    }
}

if (-not (Test-Path $appxPath) -or ((Get-Item $appxPath).Length -lt 10MB)) {
    Write-Error "[INCXGNITE] Download failed or file corrupted."
    Set-Location 'C:\'
    Remove-Item -Path $mvFixedAppxPath -Recurse -Force
    Start-Sleep -Seconds 5
    Exit
}

$isBackupActive = (Read-Host -Prompt 'Do you want to preserve your data and worlds? Enter 1 to save, 2 to discard').Trim()
$baseDir = "$env:LOCALAPPDATA\Packages"
$dataDir = "$baseDir\Microsoft.MinecraftUWP_8wekyb3d8bbwe"

if ($isBackupActive -eq '1') {
    if (Test-Path $dataDir) {
        Write-Information "[INCXGNITE] Saving backup of worlds..."
        Copy-Item -LiteralPath $dataDir -Recurse -Destination "$mvFixedAppxPath\oldData"
    } else {
        Write-Warning "[INCXGNITE] No previous data found for backup."
        $isBackupActive = '2'
    }
}

if (Get-AppxPackage *minecraft*) {
    Write-Information "[INCXGNITE] Uninstalling current version of Minecraft..."
    Get-AppxPackage *minecraft* | Remove-AppxPackage

    if (-not (Get-AppxPackage *minecraft*)) {
        Write-Information "[INCXGNITE] Successful uninstallation."
    } else {
        Write-Error "[INCXGNITE] Error uninstalling the current version."
        Set-Location 'C:\'
        Remove-Item -Path $mvFixedAppxPath -Recurse -Force
        Start-Sleep -Seconds 5
        Exit
    }
}

Write-Information "[INCXGNITE] Installing Minecraft package..."
Add-AppxPackage -Path $appxPath

if (Get-AppxPackage *minecraft*) {
    Write-Information "[INCXGNITE] Minecraft was installed successfully."
} else {
    Write-Error "[INCXGNITE] Error during package installation."
    Set-Location 'C:\'
    Remove-Item -Path $mvFixedAppxPath -Recurse -Force
    Start-Sleep -Seconds 5
    Exit
}

if ($isBackupActive -eq '1') {
    Write-Information "[INCXGNITE] Restoring your data and worlds..."
    if (Test-Path $dataDir) {
        Remove-Item -Path $dataDir -Recurse -Force
    }
    Copy-Item -LiteralPath "$mvFixedAppxPath\oldData\Microsoft.MinecraftUWP_8wekyb3d8bbwe" -Recurse -Destination $baseDir -Force
}

Write-Information "[INCXGNITE] Cleaning temporary files..."
Set-Location 'C:\'
Remove-Item -Path $mvFixedAppxPath -Recurse -Force

Write-Host "==========================================================================" -ForegroundColor Green
Write-Host "       [INCXGNITE DOWNGRADE VERSION] PROCESS COMPLETED SUCCESSFULLY!      " -ForegroundColor Green
Write-Host "==========================================================================" -ForegroundColor Green
Write-Host "Join this Discord:" -ForegroundColor Yellow
Write-Host "https://discord.gg/vEBypNjnT6" -ForegroundColor Cyan
Start-Process "https://discord.gg/vEBypNjnT6"

Write-Warning "Closing script in 5 seconds..."
Start-Sleep -Seconds 5

$parentPid = (Get-CimInstance Win32_Process -Filter "ProcessId = $PID").ParentProcessId
Stop-Process -Id $parentPid -Force -ErrorAction SilentlyContinue
Stop-Process -Id $PID -Force