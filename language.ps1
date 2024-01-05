# Set norwegian keyboard layout
$languageList = New-WinUserLanguageList -Language "nb-NO"
$languageList[0].InputMethodTips.Add("0414:00000414")
Set-WinUserLanguageList $languageList -Force