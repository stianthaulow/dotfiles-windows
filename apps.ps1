$apps = @(
    @{Id = "JanDeDobbeleer.OhMyPosh"; Name = "Oh My Posh" },
    @{Id = "7zip.7zip"; Name = "7zip" },
    @{Id = "Microsoft.WindowsTerminal"; Name = "Windows Terminal" },
    @{Id = "Google.Chrome"; Name = "Google Chrome" },
    @{Id = "Neovim.Neovim"; Name = "Neovim" },
    @{Id = "Microsoft.PowerToys"; Name = "PowerToys" },
    @{Id = "Microsoft.VisualStudioCode"; Name = "Visual Studio Code"; Args = "--override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" },
    @{Id = "AutoHotkey.AutoHotkey"; Name = "AutoHotkey" },
    @{Id = "Spotify.Spotify"; Name = "Spotify" },
    @{Id = "Ditto.Ditto"; Name = "Ditto" },
    @{Id = "GitHub.cli"; Name = "GitHub CLI" }
    @{Id = "jqlang.jq"; Name = "jq (JSON CLI)" }
    @{Id = "junegunn.fzf"; Name = "fzf (fuzzy finder)" }
    @{Id = "Schniz.fnm"; Name = "Fast Node Manager (fnm)" },
    @{Id = "Obsidian.Obsidian"; Name = "Obsidian" },
    @{Id = "Notepad++.Notepad++"; Name = "Notepad++" },
    @{Id = "Bitwarden.Bitwarden"; Name = "Bitwarden" },
    @{Id = "DigitalScholar.Zotero"; Name = "Zotero" },
    @{Id = "voidtools.Everything"; Name = "Everything search" },
    @{Id = "Discord.Discord"; Name = "Discord" },
    @{Id = "tailscale.tailscale"; Name = "Tailscale" },
    @{Id = "NickeManarin.ScreenToGif"; Name = "ScreenToGif" }
    @{Id = "WireGuard.WireGuard"; Name = "WireGuard" }
    @{Id = "suse.RancherDesktop"; Name = "Rancher Desktop" }
    @{Id = "Python.Python.3.10"; Name = "Python 3.10" }
    @{Id = "Python.Python.3.12"; Name = "Python 3.12" }
    @{Id = "Microsoft.DotNet.SDK.8"; Name = ".NET 8 SDK" }
)

function List($apps, $currentSelection, $selectedApps) {
    for ($i = 0; $i -lt $apps.Count; $i++) {
        if ($i -eq $currentSelection) {
            Write-Host "-> $($apps[$i].Name)" -ForegroundColor Cyan
        }
        elseif ($selectedApps -contains $i) {
            Write-Host "[x] $($apps[$i].Name)"
        }
        else {
            Write-Host "[ ] $($apps[$i].Name)"
        }
    }
}

$currentIndex = 0
$selectedApps = 0..($apps.Count - 1)

do {
    Clear-Host
    Write-Host "Select Applications to Install" -ForegroundColor Green
    Write-Host "Press [Space] to toggle selection, [A] to select all, [Enter] to continue" -ForegroundColor DarkGray
    List $apps $currentIndex $selectedApps

    $key = [System.Console]::ReadKey($true)

    switch ($key.Key) {
        'UpArrow' {
            if ($currentIndex -gt 0) { $currentIndex-- }
        }
        'DownArrow' {
            if ($currentIndex -lt $apps.Count - 1) { $currentIndex++ }
        }
        'Spacebar' {
            if ($selectedApps -contains $currentIndex) {
                $selectedApps = $selectedApps | Where-Object { $_ -ne $currentIndex }
            }
            else {
                $selectedApps += $currentIndex
            }
        }
        'A' {
            if ($selectedApps -contains $currentIndex) {
                $selectedApps = @()
            }
            else {
                $selectedApps = 0..($apps.Count - 1)
            }
        }
        'Enter' {
            break
        }
    }
} while ($key.Key -ne 'Enter')


If ($selectedApps.Count -ne 0) {
    Write-host "Installing apps..." -ForegroundColor Green
    foreach ($index in $selectedApps) {
        $appId = $apps[$index].Id
        $appName = $apps[$index].Name
        $appArgs = $apps[$index].Args
        $listApp = winget list --exact -q $appId
        if (![String]::Join("", $listApp).Contains($appId)) {
            Write-host "Installing: " $appId
            $wingetArgs = "install -e -h --accept-source-agreements --accept-package-agreements --id $appId $appArgs"
            Invoke-Expression "winget $wingetArgs"
        }
        else {
            Write-host "Skipping: " $appName " (already installed)" -ForegroundColor DarkGray
        }
    }
}
