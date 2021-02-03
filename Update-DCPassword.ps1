#Small object to make the handling of credentials simpler.
class CredObject {
    $Username
    $Password
}

#Create the session to the domain controller.
$dcSession = Create-Session -Ip 10.0.0.10 -Username "Administrator" -Password "MyVerySecurePassword"

#Get all the users who aren't the Administrator
$users = Invoke-Command -Session $dcSession -ScriptBlock {Get-AdUser -Filter * | ? {$_.Enabled -eq $true -and $_.Name -notin ("Administrator")}}

#Iterate over all the users and create a new password. The new credentials will be exported as an array in $newCreds.
$newCreds = $users | % {

    #Create the new credentials for the user.
    $newCred = New-Object CredObject
    $newCred.Username = $_.Name
    $newCred.Password = Generate-Password #This function needs to be instantiated from a separate gist first.

    #Convert the new password to a Secure String object.
    $securePassword = ConvertTo-SecureString -AsPlainText $newCred.Password -Force

    #Update the user with the new password
    Invoke-Command -Session $dcSession -ScriptBlock {
        param($username, $securePassword)
        Set-ADAccountPassword -Identity $username -NewPassword $securePassword
    } -ArgumentList $_.Name, $securePassword

    #Return the new credential so that it can be saved
    $newCred
}

#Export the new credentials as a CSV
$newCreds | Select-Object -Property Username, Password | Export-Csv -Path "newDomainCreds.csv"