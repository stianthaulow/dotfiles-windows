# Disable Startup Sound
$SystemPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
if (Test-Path $SystemPolicyPath) {
  Set-ItemProperty $SystemPolicyPath "DisableStartupSound" 1
}

$LogonUIPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation"
if (Test-Path $LogonUIPath) {
  Set-ItemProperty $LogonUIPath "DisableStartupSound" 1
}