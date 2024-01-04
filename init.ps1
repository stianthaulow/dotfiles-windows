if ($PSVersionTable.PSEdition -ne "Core") {
  try {
    $null = Get-Command pwsh -ErrorAction Stop
    Write-Host "Run this script under Powershell Core" -ForegroundColor Red
    exit
  } catch {
      winget install Microsoft.PowerShell
  }
}

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$isAdmin) {
  Write-Host "Please run this script as administrator" -ForegroundColor Red
  exit
}

# Create Powershell profile directory if it doesn't exist
$profileDir = Split-Path -parent $profile
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

# Copy profile to profile directory
Write-host "Copying Powershell profile to: `"$profileDir`"..." -ForegroundColor Green
Copy-Item -Path ./Microsoft.PowerShell_profile.ps1 -Destination $profileDir 

$directoriesToCreate = @(
  "C:\Dev",
  "C:\Tools"
)
foreach ($directory in $directoriesToCreate) {
  if (-not (Test-Path $directory)) {
      # The directory does not exist, so create it
      New-Item -Path $directory -ItemType Directory
      Write-Host "Created directory: $directory" -ForegroundColor Green
  }   
}

# Install Windows Subsystem for Linux
$wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
if ($wslFeature -and $wslFeature.State -ne "Enabled") {
    Write-host "Install wsl? [Y/n]" -ForegroundColor Yellow
    $key = [System.Console]::ReadKey($true)
    if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
        wsl --install
    }
} 

# Default settings
Write-host "Set windows defaults? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
      Start-Process Powershell -ArgumentList "-File `"$PSScriptRoot\windows-defaults.ps1`"" -Verb RunAs
}

# Install apps
Write-host "Install applications? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
  & "$PSScriptRoot\apps.ps1"
}

# Ahk workscript
Write-host "Install ahk workscript? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
  & "$PSScriptRoot\ahk-workscript.ps1"
}
