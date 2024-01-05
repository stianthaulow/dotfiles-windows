# Windows 10 dotfiles

Run
```powershell
init.ps1
```
to install

## New box

### winget in MS Store:
https://apps.microsoft.com/detail/9NBLGGH4NNS1?rtc=1&hl=en&gl=US

### Git
```powershell
winget install Git.Git
```
### Powershell Core
```powershell
winget install Microsoft.Powershell
```

### Set Windows powershell execution policy
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

`*Run powershell as admin*`

### Clone repo
```powershell
git clone https://github.com/stianthaulow/dotfiles-windows.git .dotfiles && cd .dotfiles
```
