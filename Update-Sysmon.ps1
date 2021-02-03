#Change to full path of the credentials file with columns: Name, Ip, Username, Password
$machines = Import-CSV -Path "\path\to\machines.csv"

#Change to full path of the sysmon configuration file
$sysmonConfig = "\path\to\sysmonconfig-export.xml"

#You can iterate all machines or change to the index of the machines to which you want to deploy sysmon. Exempli Gratia: machine-1 to machine-10 is $machines[0..9]
$machines | % {
    Write-Host "Connecting to $($_.Name)"
    $session = Create-Session -Ip $_.Ip -Username $_.Username -Password $_.Password

    Write-Host "Copying Sysmon configuration file."
    Copy-Item -ToSession $session -Path $sysmonConfig -Destination C:\

    Write-Host "Updating Sysmon configuration on remote machine."
    Invoke-Command -Session $session -ScriptBlock {
        Sysmon64 -accepteula -c C:\sysmonconfig-export.xml
        Remove-Item -Path C:\sysmonconfig-export.xml
    }

    Write-Host "Update complete, closing session..."
    Remove-PSSession -Session $session
}