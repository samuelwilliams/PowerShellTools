#Change to full path of the credentials file with columns: Name, Ip, Username, Password
$machines = Import-CSV -Path "\path\to\machines.csv"

#Change to full path of the sysmon configuration file
$sysmonConfig = "\path\to\sysmonconfig-export.xml"

#Change to full path of the Sysmon executable to be deployed
$sysmonExe = "\path\to\Sysmon64.exe"

#You can iterate all machines or change to the index of the machines to which you want to deploy sysmon. Exempli Gratia: machine-1 to machine-10 is $machines[0..9]
$machines | % {
    Write-Host "Connecting to $($_.Name)"

    #This may need to be changed depending on how your sessions are created.
    $session = Create-Session -Ip $_.Ip -Username $_.Username -Password $_.Password

    Write-Host "Copying Sysmon binary and configuration files to target PC."
    Copy-Item -ToSession $session -Path @($sysmonExe, $sysmonConfig) -Destination C:\

    Write-Host "Installing Sysmon configuration on remote machine."
    Invoke-Command -Session $session -ScriptBlock {
        sysmon -u #Uninstall the existing version of Sysmon
        C:\Sysmon64.exe -accepteula -i C:\sysmonconfig-export.xml
        Remove-Item -Path C:\Sysmon64.exe
        Remove-Item -Path C:\sysmonconfig-export.xml
    }

    Write-Host "Deployment complete, closing session..."
    Remove-PSSession -Session $session
}