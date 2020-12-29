# Rename local Admin and change password

$securedValue = Read-Host 'New Administrator password' -AsSecureString
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedValue)
$value = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

if((Get-LocalUser -Name Administrator -ErrorAction SilentlyContinue) -and (-not (Get-LocalUser -name wAdmin))){
    Rename-LocalUser Administrator -NewName wAdmin -Confirm:$true
    Set-LocalUser wAdmin -Password $securedValue -Confirm:$true
}

# Set password policy

Set-LocalUser $env:USERNAME -PasswordNeverExpires $false -Confirm:$true

# Get OS info

New-Item .\Output\$env:COMPUTERNAME -ItemType Directory

gcim Win32_OperatingSystem | Select-Object Version, InstallDate, OSArchitecture -OutVariable OS
$OS > .\Output\$env:COMPUTERNAME\OS.txt

Get-HotFix | Sort-Object InstalledOn -OutVariable Updates
$OS > .\Output\$env:COMPUTERNAME\Updates.txt

# Troubleshooting

# secpol.msc
# start ms-settings:
# control appwiz.cpl
# MinimumPasswordAge = 3
# MaximumPasswordAge = 90
# MinimumPasswordLength = 8
# PasswordComplexity = 1
# PasswordHistorySize = 7
