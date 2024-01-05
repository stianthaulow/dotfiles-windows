# Set norwegian keyboard layout
$languageList = New-WinUserLanguageList -Language "nb-NO"
$languageList.Add("en-US")
$languageList[0].InputMethodTips.Add("0414:00000414")
Set-WinUserLanguageList $languageList -Force
Set-Culture "nb-NO"
Set-WinSystemLocale "nb-NO"
Set-WinUILanguageOverride -Language "en-US"