# Get list of sites from IIS and their bindings/host headers and check what they resolve to in Public DNS
#
# Name: Resolve-IISsites.ps1
# Version: 1.0
# Date: 28/07/2017
# Compatibility: Windows 2012+ (Uses the Resolve-DnsName cmdlet)
#
# Script Arguments:
#
# -File  // OPTIONAL - Enter file path and name, if blank default file "Resolved-sites.csv" is created in current directory
# -DnsServer  // OPTIONAL - Query a specific DNS Server, if blank uses 8.8.8.8
# -Verbose  // OPTIONAL - Show debug/verbose output at console

[CmdletBinding()]

param (

[string]$File,
[string]$DnsServer

)

if (!$File) {
    $File = "Resolved-sites.csv"
}

if (!$DnsServer) {
    $DnsServer = "8.8.8.8"
}


$csvCol = "Name,Binding,IPAddress"

$csvCol | Out-File $File

$sites = Get-Website

foreach ($site in $sites) {
    
    $name = $site.name
    $binding = Get-WebBinding -Name $site.name
    
    foreach ($bind in $binding) {
        $binds = $bind.bindingInformation
        $binds = $binds.split(':')[2]
        $publicAddr = Resolve-DnsName $binds -Server $DnsServer -DnsOnly -Type A |Select-Object -First 1
        $addr = $publicAddr.IPAddress
        if (!$addr) {
            $publicAddr = Resolve-DnsName $binds -Server $DnsServer -DnsOnly -Type CNAME |Select-Object -First 1
            $addr = $publicAddr.NameHost
            if (!$addr) {
                $addr = "No DNS Data"
            }
            else {
                $addr = "CNAME->"+$addr
            }
        }
        write-Verbose $name
        write-Verbose $binds
        write-Verbose $addr
        $output = $name+","+$binds+","+$addr
        $output | Out-File $File -Append
    }
}