param (
    [string]$vcsa='vcsacluster.ouiit.local',
    [string]$user='Administrator@vsphere.local'
)

Connect-VIServer -Server $vcsa -User $user -Password $Env:TF_VAR_vsphere_password -Force | out-null

$networks=$Env:networks
$nets = $networks.Split(",")

$count = 0
$timeout = 60
$done = $false

while(!$done){
    $vcsa_nets = $(Get-VirtualNetwork -NetworkType Distributed).Name
    foreach($net in $nets){
        if($net -in $vcsa_nets){
            $count += 1
        }
        else {
            Write-Host "[-] Wait for $($net)"
        }
    
    }
    if($count -eq $nets.Length){ $done = $true }
    $count = 0
    $timeout -= 1
    if($timeout -le 0){ $done = $true }
}

Disconnect-VIServer -Server $vcsa -Confirm:$false