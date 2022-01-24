$computer_name = $(Get-WmiObject Win32_ComputerSystem).Name;

$network_conf = $false
$ipaddr = Get-NetAdapter -Name Eth* | Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Ignore
$gw = $(Get-NetRoute -AddressFamily IPv4 -DestinationPrefix "0.0.0.0/0" -ErrorAction Ignore).NextHop
if(($ipaddr.IPAddress -eq "192.168.100.200") -and ($ipaddr.PrefixLength -eq 24) -and ($gw -eq "192.168.100.254")){
    $network_conf = $true
}

$ntp = $(Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "NtpServer").NtpServer.startswith("4.4.4.1")

$dnsrole=( (Get-WindowsFeature -name "dns" ).installstate -eq "Installed" )
if($dnsrole){
    $dns_fzone = ((Get-DnsServerZone -Name "int.demo.wsr" -ErrorAction Ignore).Zonename -eq "int.demo.wsr" )
    $dns_rzone_right = ((Get-DnsServerZone -Name "100.16.172.in-addr.arpa" -ErrorAction Ignore).Zonename -eq "100.16.172.in-addr.arpa" )
    $dns_rzone_left = ((Get-DnsServerZone -Name "100.168.192.in-addr.arpa" -ErrorAction Ignore).Zonename -eq "100.168.192.in-addr.arpa" )
    if($dns_fzone) {
        $dnsrecord = (Get-DnsServerResourceRecord -ZoneName "int.demo.wsr" -ErrorAction Ignore).HostName
    } else { $dnsrecord = $false }
}
else {
    $dns_fzone       = $false
    $dns_rzone_right = $false
    $dns_rzone_left  = $false
    $dnsrecord       = $false
}

$dnsrecord_conf  = $false
if (("rtr-l" -in $dnsrecord) -and ( "rtr-r" -in $dnsrecord)) {
    $dnsrecord_conf  = $true
}

$raid = (Get-VirtualDisk ).ResiliencySettingName
$drive_latter = (Get-Partition -DriveLetter "R" -ErrorAction Ignore).DriveLetter

$ca      = $false 
$ca_days = $false 
if((Get-WindowsFeature -Name  AD-Certificate).installstate  -eq 'Installed'){ 
    $adcscert = Get-ChildItem -Path 'Cert:LocalMachine\MY' | Where-Object Subject -EQ 'CN=Demo.wsr'
    if($adcscert){  
        $ca = $true 
        $ca_days = if (($adcscert.NotAfter - $adcscert.NotBefore).Days -ge 500){ $true } else { $false } 
    } 
}

$nfs_share = Get-NfsShare -ErrorAction Ignore | Where-Object { $_.Path -match '^R:\.*'} | Get-NfsSharePermission | Where-Object { $_.Permission -eq 'readwrite'}
$clients = (Get-NfsMountedClient -ErrorAction Ignore).ClientIpAddress
$nfs_clients = if ($clients -and ('172.16.100.100' -in $clients) -and ('192.168.100.100') -in $clients){ $true }else{$false}

$smb_share = Get-SmbShare -ErrorAction Ignore | Where-Object { ($_.Description -ne 'Default share') -and ($_.Path -match '^R:.*')} 
$clients = (Get-SmbSession -ErrorAction Ignore).ClientComputerName 
$smb_clients = if ( $clients -and ('192.168.100.100' -in $clients) -and ('172.16.100.100' -in $clients)) { $true } else { $false }

@{
    "hostname"        = $($computer_name -eq "SRV")
    "netconf"         = $network_conf
    "ntp"             = $ntp
    "dnsrole"         = $dnsrole
    "dns_fzone"       = $dns_fzone
    "dns_rzone_right" = $dns_rzone_right
    "dns_rzone_left"  = $dns_rzone_left
    "dnsrecord"       = $dnsrecord_conf
    "raid"            = $($raid -eq "Mirror")
    "drive_letter"    = if($drive_latter -eq "R"){ $true } else { $false }
    "ca"              = $ca
    "ca_days"         = $ca_days
    "nfs_share"       = if($nfs_share){ $true } else { $false }
    "nfs_clients"     = $nfs_clients
    "smb_share"       = if($smb_share){ $true } else { $false }
    "smb_clients"     = $smb_clients
} | ConvertTo-Json