# Create profile directory if it doesn't exist
$profileDir = Split-Path -parent $profile
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue

# Copy profile to profile directory
Copy-Item -Path ./Microsoft.PowerShell_profile.ps1 -Destination $profileDir
