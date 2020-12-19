# Rename local Admin and change password

$securedValue = Read-Host 'New Administrator password' -AsSecureString
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedValue)
$value = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

if(Get-LocalUser -Name Administrator){
    Rename-LocalUser Administrator -NewName wAdmin | Set-LocalUser -Password $securedValue  
}

# Set password policy

Set-LocalUser $env:USERNAME -PasswordNeverExpires $false -WhatIf