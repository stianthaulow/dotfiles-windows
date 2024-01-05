if ($PSVersionTable.PSEdition -ne "Core") {
  try {
    $null = Get-Command pwsh -ErrorAction Stop
    Write-Host "Run this script under Powershell Core" -ForegroundColor Red
    exit
  }
  catch {
    winget install Microsoft.PowerShell
  }
}

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$isAdmin) {
  Write-Host "Please run this script as administrator" -ForegroundColor Red
  exit
}

# Create Dev and Tools dir
$directoriesToCreate = @(
  "C:\Dev",
  "C:\Tools"
)
foreach ($directory in $directoriesToCreate) {
  if (-not (Test-Path $directory)) {
    # The directory does not exist, so create it
    New-Item -Path $directory -ItemType Directory | Out-Null
    Write-Host "Created directory: $directory" -ForegroundColor Green
  }   
}

# Copy Oh My Posh theme
write-host "Copying Oh My Posh theme..." -ForegroundColor Green
$ompThemePath = "$env:POSH_THEMES_PATH\thaulow.omp.json"
Copy-Item -Path "$PSScriptRoot\Oh My Posh\thaulow.omp.json" -Destination $ompThemePath -Force

# Create Powershell profile directory if it doesn't exist
$profileDir = Split-Path -parent $profile
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

# Copy profile to profile directory
Write-host "Copy powershell profile? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
  Write-host "Copying Powershell profile to: `"$profileDir`"..." -ForegroundColor Green
  Copy-Item -Path $PSScriptRoot\Microsoft.PowerShell_profile.ps1 -Destination $profileDir
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

# Install Fonts
Write-host "Install fonts? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
  Start-Process Powershell -ArgumentList "-File `"$PSScriptRoot\install-fonts.ps1`"" -Verb RunAs
}


# Default settings
Write-host "Set windows defaults? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
  & "$PSScriptRoot\windows-defaults.ps1"
}

# Install apps
Write-host "Install applications? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
  & "$PSScriptRoot\apps.ps1"
}

# Windows Terminal settings
Write-host "Set windows terminal settings? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
  $wtSettingsPath = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
  Copy-Item -Path "$PSScriptRoot\Windows Terminal\settings.json" -Destination $wtSettingsPath -Force
  if (Test-Path -Path "$wtSettingsPath\state.json") {
    $wtState = Get-Content -Path "$wtSettingsPath\state.json" | ConvertFrom-Json
    $keyName = "dismissedMessages"
    if (-not $wtState.PSObject.Properties.Name.Contains($keyName)) {
      $wtState | Add-Member -MemberType NoteProperty -Name $keyName -Value @("setAsDefault")
    }
    else {
      $wtState.$keyName = "[`"setAsDefault`"]"
    }
    $jsonString = $wtState | ConvertTo-Json
    Write-Host $jsonString
    Set-Content "$wtSettingsPath\state.json" -Value $jsonString
  }
  else {
    Copy-Item -Path "$PSScriptRoot\Windows Terminal\state.json" -Destination $wtSettingsPath -Force
  }
}

# Ahk workscript
Write-host "Install ahk workscript? [Y/n]" -ForegroundColor Yellow
$key = [System.Console]::ReadKey($true)
if ($key.Key -eq 'Y' -or $key.Key -eq 'Enter') {
  & "$PSScriptRoot\ahk-workscript.ps1"
}
