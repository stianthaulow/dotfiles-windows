
$apps = @(
  @{name = "7zip.7zip" },
  @{name = "Microsoft.WindowsTerminal" }
)

foreach ($app in $apps) {
  $listApp = winget list --exact -q $app.name
  if (![String]::Join("", $listApp).Contains($app.name)) {
      Write-host "Installing: " $app.name
      winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name 
  }
  else {
      Write-host "Skipping: " $app.name " (already installed)"
  }
}