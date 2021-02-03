Function ConvertTo-RDataString {
    <#
        .SYNOPSIS
            Turns a RecordData object into a human readable string.

        .DESCRIPTION
            Turns a RecordData object into a human readable string.

        .EXAMPLE
            Get-DnsServerResourceRecord -ZoneName "contoso.com" | Select-Object -Property HostName,TimeToLive,RecordClass,RecordType,@{Label="Rdata"; Expression={$_.RecordData | ConvertTo-RDataString}} | FT
    #>
    Param(
        [parameter(ValueFromPipeline=$True)]$RecordData
    )

    if ($RecordData.NameServer) {return $RecordData.NameServer}
    if ($RecordData.DomainName) {return $RecordData.DomainName}
    if ($RecordData.IPv4Address) {return $RecordData.IPv4Address}
    if ($RecordData.HostNameAlias) {return $RecordData.HostNameAlias}
    if ($RecordData.PtrDomainName) {return $RecordData.PtrDomainName}
    if ($RecordData.PrimaryServer) {return $RecordData.PrimaryServer +" "+ $RecordData.ResponsiblePerson + " " + $RecordData.SerialNumber + " " + $RecordData.MinimumTimeToLive + " " + $RecordData.RefreshInterval + " " + $RecordData.RetryDelay }
}