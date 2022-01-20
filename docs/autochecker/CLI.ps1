add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem) { return true; }
}
"@

$dns_name="www.demo.wsr";
$redirects = 0;
$http = 0;
$https = 0;

$ips = ("4.4.4.100", "5.5.5.100");
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$ips | ForEach-Object { try {
 $result = Invoke-WebRequest -UseBasicParsing -URI "http://$_" -Headers @{ host="$dns_name"} -MaximumRedirection 0 -TimeoutSec 2 -ErrorAction SilentlyContinue
 if ($result.StatusCode -in ( "301", "302", "303", "307", "308" )){
    $redirects += 1
 }
 $result = Invoke-WebRequest -UseBasicParsing -URI "http://$_" -Headers @{ host="$dns_name"} -TimeoutSec 2 -ErrorAction SilentlyContinue
 if(($result.StatusCode -eq "200") -and ($result.Content -match "WSR39 - Docker site")) {
    $http += 1
 }
 $result = Invoke-WebRequest -UseBasicParsing -URI "https://$_" -Headers @{ host="$dns_name"} -TimeoutSec 2 -ErrorAction SilentlyContinue
 if(($result.StatusCode -eq "200") -and ($result.Content -match "WSR39 - Docker site")) {
    $https += 1
 }
} catch { } } | Out-Null

$dns_table = @{
    "www.demo.wsr" =  ("4.4.4.100", "5.5.5.100")
    "isp.demo.wsr" = ("3.3.3.1")
    "internet.demo.wsr" = ("3.3.3.1")
}
$answers = $($dns_table.Keys).Length; $right_answers = $answers;

$dns_table.Keys | ForEach-Object {
  $expected_ip = $($dns_table[$_] | Sort-Object)
  try {
   $answer = $($(Resolve-DnsName -Name $_ -Server 3.3.3.1 -NoHostsFile -DnsOnly -QuickTimeout -ErrorAction Ignore).IPAddress | Sort-Object)
   $result = Compare-Object $expected_ip $answer;
   if($result){
    $right_answers -= 1
   }
  } catch {
        $right_answers -= 1
  }
} | Out-Null

$computer_name = $(Get-WmiObject Win32_ComputerSystem).Name; $network_conf = $false
$ipaddr = Get-NetAdapter -Name Eth* | Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Ignore
$gw = $(Get-NetRoute -AddressFamily IPv4 -DestinationPrefix "0.0.0.0/0" -ErrorAction Ignore).NextHop
$ntp = $(Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "NtpServer").NtpServer.startswith("4.4.4.1")

if(($ipaddr.IPAddress -eq "3.3.3.10") -and ($ipaddr.PrefixLength -eq 24) -and ($gw -eq "3.3.3.1")){
    $network_conf = $true
}

@{
    "hostname" =  $($computer_name -eq "CLI")
    "netconf" =  $network_conf
    "ntp" =  $ntp
    "dns" = $($right_answers -eq $answers)
    "redirections" = $($redirects -eq 2)
    "http" = $($http -eq 2)
    "https" = $($https -eq 2)
} | ConvertTo-Json