# Resolve-IISsites
Get list of sites from IIS and their bindings/host headers and check what they resolve to in Public DNS

Name: Resolve-IISsites.ps1\
Version: 1.0\
Date: 28/07/2017\
Compatibility: Windows 2012+ (Uses the Resolve-DnsName cmdlet)\

Script Arguments:

-File  // OPTIONAL - Enter file path and name, if blank default file "Resolved-sites.csv" is created in current directory\
-DnsServer  // OPTIONAL - Query a specific DNS Server, if blank uses 8.8.8.8\
-Verbose  // OPTIONAL - Show debug/verbose output at console\
