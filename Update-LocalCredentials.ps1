#Small object to simplify the handling of credentials.
class CredObject {
    $Name
    $Ip
    $Username
    $Password
}

#Change to full path of the credentials file with columns: Name, Ip, Username, Password
$machines = Import-CSV -Path "\path\to\machines.csv"

#Path to where the new machine credentials are going to be stored
$newCredentialsFilename = "\path\to\MachineCredentials.csv"

#Change to the index of the machines to which you want to deploy sysmon. Exempli Gratia: machine-1 to machine-10 is $machines[0..9]
$newCredentials = $machines | % {
    Write-Host "Opening session on $($_.Name)"
    #Open session to remote machine, this may need to be changed depending on your group policy
    $session = Create-Session -Ip $_.Ip -Username $_.Username -Password $_.Password

    #Create the new credentials for the user.
    $adminCred = New-Object CredObject
    $adminCred.Name = $_.Name
    $adminCred.Ip = $_.Ip
    $adminCred.Username = $_.Username
    $adminCred.Password = Generate-Password #This function needs to be instantiated from a separate gist first.

    Write-Host "Rolling admin credentials on $($_.Name)"
    Write-Host "Username: $($adminCred.Username)"
    Write-Host "Password: $($adminCred.Password)"

    #Update the user with the new password
    Invoke-Command -Session $session -ScriptBlock {
        param($luser, $lpwd)
        net user $luser $lpwd
    } -ArgumentList $adminCred.Username, $adminCred.Password

    #Close the session
    Write-Host "Closing session on $($_.Name)"
    Remove-PSSession -Session $session

    $adminCred
}

Export-Csv -InputObject $newCredentials -Path $newCredentialsFilename

Write-Host "New credentials writted to $newCredentialsFilename"