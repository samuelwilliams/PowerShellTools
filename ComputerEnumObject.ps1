Class EnumObject {
    [string]$ComputerName
    $Session
    $Users
    $NetConnections
    $Groups
    $RunKeys
    $TempDir
    $Services
    $ScheduledTasks
    $Processes
    $ComputerInfo
    $Startup
    $NetAdapters
    $DNSCache
    $InstalledApplications
    $Patches
    $ArpCache
    $FirewallRules
    $HostsFile
    $TimeZone
    $EnumStartDatetime
    $EnumEndDatetime
    $MpComputerStatus
    $SmbShares
    $SmbConnections
    $PsVersion
    $LocalTime

    InitialiseSession($cred) {
        $this.Session = New-PsSession -ComputerName $this.ComputerName -Credential $cred -Authentication Negotiate
    }

    RemoveSession() {
        Remove-PSSession -Session $this.Session
    }

    GetPsVersion() {
        $this.PsVersion = Invoke-Command -Session $this.Session -ScriptBlock {$PSVersionTable} -ErrorAction SilentlyContinue
    }

    GetStartDatetime() {
        $this.EnumStartDatetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss K"
    }

    GetEndDatetime() {
        $this.EnumEndDatetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss K"
    }

    GetSystemLocalTime() {
        $this.LocalTime = Invoke-Command -Session $this.Session -ScriptBlock {Get-Date -Format "yyyy-MM-dd HH:mm:ss K"} -ErrorAction SilentlyContinue
    }

    GetSmbShares() {
        $this.SmbShares = Invoke-Command -Session $this.Session -ScriptBlock {Get-SmbShare} -ErrorAction SilentlyContinue
    }

    GetSmbConnections() {
        $this.SmbConnections = Invoke-Command -Session $this.Session -ScriptBlock {Get-SmbConnection} -ErrorAction SilentlyContinue
    }

    GetTimeZone() {
        $this.TimeZone = Invoke-Command -Session $this.Session -ScriptBlock {tzutil /g} -ErrorAction SilentlyContinue
    }

    GetMpComputerStatus() {
        $this.MpComputerStatus = Invoke-Command -Session $this.Session -ScriptBlock {Get-MpComputerStatus} -ErrorAction SilentlyContinue
    }

    GetDnsCache() {
        $this.DNSCache = Invoke-Command -Session $this.Session -ScriptBlock {Get-DnsClientCache} -ErrorAction SilentlyContinue
    }

    GetArpCache() {
        $this.ArpCache = Invoke-Command -Session $this.Session -ScriptBlock {Get-NetNeighbor} -ErrorAction SilentlyContinue
    }

    GetFirewallRules() {
        $this.FirewallRules = Invoke-Command -Session $this.Session -ScriptBlock {Get-NetFirewallRule} -ErrorAction SilentlyContinue
    }

    GetHostsFile() {
        $this.HostsFile = Invoke-Command -Session $this.Session -ScriptBlock {Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"} -ErrorAction SilentlyContinue
    }

    GetInstalledApplications() {
        $this.InstalledApplications = Invoke-Command -Session $this.Session -ScriptBlock {Get-CimInstance -ClassName Win32_Product} -ErrorAction SilentlyContinue
    }

    GetPatches() {
        $this.Patches = Invoke-Command -Session $this.Session -ScriptBlock {Get-CimInstance -ClassName Win32_QuickFixEngineering} -ErrorAction SilentlyContinue
    }

    GetUsers() {
        $this.Users = Invoke-Command -Session $this.Session -ScriptBlock {Get-CimInstance -ClassName Win32_UserAccount} -ErrorAction SilentlyContinue
    }

    GetGroups() {
        $this.Groups = Invoke-Command -Session $this.Session -ScriptBlock {Get-CimInstance -ClassName Win32_Group} -ErrorAction SilentlyContinue
    }

    GetNetConnections() {
        $this.NetConnections = Invoke-Command -Session $this.Session -ScriptBlock {Get-NetTCPConnection} -ErrorAction SilentlyContinue
    }

    GetNetAdapters() {
        $this.NetAdapters = Invoke-Command -Session $this.Session -ScriptBlock {Get-NetAdapter} -ErrorAction SilentlyContinue
    }

    GetRunKeys() {
        $this.RunKeys = Invoke-Command -Session $this.Session -ScriptBlock {Get-ItemProperty -Path @('Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run', 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run')} -ErrorAction SilentlyContinue
    }

    GetServices() {
        $this.Services = Invoke-Command -Session $this.Session -ScriptBlock {Get-CimInstance -ClassName Win32_Service} -ErrorAction SilentlyContinue
    }

    GetScheduledTasks() {
        $this.ScheduledTasks = Invoke-Command -Session $this.Session -ScriptBlock {Get-ScheduledTask} -ErrorAction SilentlyContinue
    }

    GetProcesses() {
        $this.Processes = Invoke-Command -Session $this.Session -ScriptBlock {Get-CimInstance -ClassName Win32_Process} -ErrorAction SilentlyContinue
    }

    GetComputerInfo() {
        $this.ComputerInfo = Invoke-Command -Session $this.Session -ScriptBlock {systeminfo} -ErrorAction SilentlyContinue
    }

    GetStartup() {
        $this.Startup = Invoke-Command -Session $this.Session -ScriptBlock {Get-CimInstance Win32_StartupCommand} -ErrorAction SilentlyContinue
    }

    GetTempDir() {
        $this.TempDir = Invoke-Command -Session $this.Session -ScriptBlock {Get-ChildItem -Path "C:\Windows\Temp" -Force -Recurse -ErrorAction SilentlyContinue}
    }

    GetAll() {
        $this.GetUsers()
        $this.GetNetConnections()
        $this.GetGroups()
        $this.GetRunKeys()
        $this.GetTempDir()
        $this.GetServices()
        $this.GetScheduledTasks()
        $this.GetProcesses()
        $this.GetComputerInfo()
        $this.GetStartup()
        $this.GetNetAdapters()
        $this.GetDnsCache()
        $this.GetInstalledApplications()
        $this.GetPatches()
        $this.GetArpCache()
        $this.GetFirewallRules()
        $this.GetHostsFile()
        $this.GetTimeZone()
        $this.GetStartDatetime()
        $this.GetEndDatetime()
        $this.GetMpComputerStatus()
        $this.GetSmbShares()
        $this.GetSmbConnections()
        $this.GetPsVersion()
        $this.GetSystemLocalTime()
    }
}