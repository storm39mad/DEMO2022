param (
    [string]$vcsa='vcsacluster.ouiit.local',
    [string]$user='Administrator@vsphere.local',
    [string]$regex='TF_*_',
    [string]$role='DEMOEX2022',
    [string]$userlist='students.json'
)

Connect-VIServer -Server $vcsa -User $user -Password $Env:TF_VAR_vsphere_password -Force | out-null

$role = Get-VIRole -Name $role

$students = ( Get-Content $userlist | ConvertFrom-Json )
$count = 0

foreach($student in $students){
    $nets = Get-VirtualNetwork -Name $($regex+$count.ToString())
    if ($nets.length -gt 0){
        $nets | New-VIPermission -Principal "KP11\$($student)" -Role $role
    }
    $count+=1
}

Disconnect-VIServer -Server $vcsa -Confirm:$false