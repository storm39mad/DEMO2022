function compress {
    [OutputType([String])]
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName='script',
                   Mandatory=$true,
                   ValueFromPipeline=$true)]
        [string]$script
    )
    $Data= foreach ($c in $script.ToCharArray()) { $c -as [Byte] }
    $ms = New-Object IO.MemoryStream
    $cs = New-Object System.IO.Compression.GZipStream ($ms, [Io.Compression.CompressionMode]"Compress")
    $cs.Write($Data, 0, $Data.Length)
    $cs.Close()
    [Convert]::ToBase64String($ms.ToArray())
    $ms.Close()
}

function payload {
    [OutputType([String])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]$script,
        [switch]$Linux,
        [switch]$Win
    )
    if($Linux){
      $vmscript = @(
        'PLAY=$(mktemp)'
        'echo {0} | base64 -d | zcat > $PLAY' -f $script
        'ANSIBLE_STDOUT_CALLBACK=json ansible-playbook --check -i localhost, -c local $PLAY | jq ''[.plays[].tasks[1:][]|{(.task.name):.hosts.localhost.changed|not}]|add'''
        '#rm -f $PLAY'
      ) -join ';'
    }
    if($Win){
      $vmscript = @(
        '$scripttext="{0}"' -f $script
        '$binaryData = [System.Convert]::FromBase64String($scripttext)'
        '$ms = New-Object System.IO.MemoryStream'
        '$ms.Write($binaryData, 0, $binaryData.Length)'
        '$ms.Seek(0,0) | Out-Null'
        '$cs = New-Object System.IO.Compression.GZipStream($ms, [IO.Compression.CompressionMode]"Decompress")'
        '$sr = New-Object System.IO.StreamReader($cs)'
        '$sr.ReadToEnd() | Invoke-Expression'
      ) | Out-String
    }
    return $vmscript
}

function Get-Marks {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Object]$results
    )
    $marks = @(
        [pscustomobject]@{
            "Name" = "A: Basic configuration"; "Max" = 0.3; "Mark" = if($results.CLI_OUT.hostname -and
                                                                        $results.SRV_OUT.hostname -and
                                                                        $results.ISP_OUT.hostname -and
                                                                        $results.WEBL_OUT.hostname -and
                                                                        $results.WEBR_OUT.hostname)
                                                                        { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "A: Network configuration"; "Max" = 0.5; "Mark" = if( $results.CLI_OUT.netconf -and 
                                                                           $results.SRV_OUT.netconf -and
                                                                           $results.WEBR_OUT.ens192 -and
                                                                           $results.WEBL_OUT.ens192 -and
                                                                           ( $results.ISP_OUT.ens192 -and $results.ISP_OUT.ens224 -and $results.ISP_OUT.ens256) -and
                                                                           ( $results.ISP_OUT.ip_forward -and $results.WEBL_OUT.gw -and $results.WEBR_OUT.gw ))
                                                                           { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "B: Only connected networks in the route table on ISP"; "Max" = 0.3; "Mark" = if ( $results.ISP_OUT.connected_only ){ 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "B: The Left and the Right offices have connectivity"; "Max" = 1; "Mark" = if(      $results.WEBL_OUT.tunnel -and
                                                                                                         $results.WEBR_OUT.tunnel -and
                                                                                                         $results.ISP_OUT.connected_only ) { 1 }
                                                                                                elseif ( $results.WEBL_OUT.tunnel -and
                                                                                                         $results.WEBR_OUT.tunnel        ) { 0.5 }
                                                                                                else    { 0 }
        },
        [pscustomobject]@{
            "Name" = "B: ICMP from WEB-L to RTR-R"; "Max" = 0.5; "Mark" = if( $results.WEBL_OUT.inet ){ 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "B: ICMP from WEB-R to RTR-L"; "Max" = 0.5; "Mark" = if( $results.WEBR_OUT.inet ){ 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "B: RTR-L has a forwarding rule for SSH from 2222 to WEB-L "; "Max" = 0.5; "Mark" = if ( $results.ISP_OUT.ssh_left ) { 0.5 } else { 0 };
        },
        [pscustomobject]@{
            "Name" = "B: RTR-R has a forwarding rule for SSH from 2244 to WEB-R "; "Max" = 0.5; "Mark" = if ( $results.ISP_OUT.ssh_right ) { 0.5 } else { 0 };
        },
        [pscustomobject]@{
            "Name" = "C: CLI has HTTP access to the application via RTR-L and RTR-R"; "Max" = 0.5; "Mark" = if ( $results.CLI_OUT.http ) { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: CLI has HTTPS access to the application via RTR-L and RTR-R"; "Max" = 0.5; "Mark" = if ( $results.CLI_OUT.https ) { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: HTTP redirects to HTTPS"; "Max" = 0.5; "Mark" = if ( $results.CLI_OUT.redirections ) { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: ISP manges demo.wsr zone and CLI can resolve dns names"; "Max" = 1; "Mark" = if ( $results.CLI_OUT.dns ) { 1 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: SRV manges int.demo.wsr zone"; "Max" = 0.5; "Mark" = if ( $results.SRV_OUT.dnsrecord ) { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: SRV has reverse zones"; "Max" = 0.5; "Mark" = if ( $results.SRV_OUT.dns_rzone_left -and -$results.SRV_OUT.dns_rzone_right ) { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: WEB-L and WEB-R use SRV as DNS server"; "Max" = 0.5; "Mark" = if ( $results.WEBL_OUT.nameserver -and -$results.WEBR_OUT.nameserver ) { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: Chrony is installed on ISP and the stratum=4"; "Max" = 0.5; "Mark" = if ( $results.ISP_OUT.chronyd_installed -and $results.ISP_OUT.chronyd_stratum ) { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: CLI uses ISP as NTP server"; "Max" = 0.3; "Mark" = if ( $results.CLI_OUT.ntp ) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: SRV uses ISP as NTP server"; "Max" = 0.3; "Mark" = if ( $results.SRV_OUT.ntp ) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: SRV has RAID Mirror"; "Max" = 0.5; "Mark" = if ( $results.SRV_OUT.raid -and $results.SRV_OUT.drive_letter ) { 0.5 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: SRV has SMB share"; "Max" = 0.3; "Mark" = if ( $results.SRV_OUT.smb_share ) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: WEB-L and WEB-R connected to SMB"; "Max" = 0.3; "Mark" = if ( $results.SRV_OUT.smb_clients ) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: CA is configured"; "Max" = 1; "Mark" = if ( $results.SRV_OUT.ca ) { 1 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "C: CA certificate expiration"; "Max" = 1; "Mark" = if ( $results.SRV_OUT.ca_days ) { 1 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "D: Docker is installed on WEB-L"; "Max" = 0.3; "Mark" = if ( $results.WEBL_OUT.docker) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "D: Docker is installed on WEB-R"; "Max" = 0.3; "Mark" = if ( $results.WEBR_OUT.docker) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "D: The application image is loaded on WEB-L"; "Max" = 0.3; "Mark" = if ( $results.WEBL_OUT.docker_image) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "D: The application image is loaded on WEB-R"; "Max" = 0.3; "Mark" = if ( $results.WEBR_OUT.docker_image) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "D: The application container is running on WEB-L"; "Max" = 0.3; "Mark" = if ( $results.WEBL_OUT.docker_container) { 0.3 } else { 0 }
        },
        [pscustomobject]@{
            "Name" = "D: The application container is running on WEB-R"; "Max" = 0.3; "Mark" = if ( $results.WEBR_OUT.docker_container) { 0.3 } else { 0 }
        }
    )
    return $marks
}

$vcsa = "vcsacluster.ouiit.local"
Connect-VIServer -Server $vcsa

$count = 0
while ($count -le 1) {

    $rp = Get-ResourcePool -Name "TF_DEMO2022-C$($count.ToString())"
    $student = ($rp | Get-VIPermission | Where-Object { $_.Role -eq 'DEMOEX2022' }).Principal.Split("\")[1]

    [System.Collections.Generic.List[System.Object]]$vms_not_started = Get-VM -Location $rp | Where-Object { $_.PowerState -ne "PoweredOn"} | Start-VM
    $timeout = 60 # I think it's dead
    while(($vms_not_started.Length -gt 0) -and ($timeout -gt 0)){
        # Get stopped VMs
        $vms_not_started = $vms_not_started | Where-Object { $_.extensionData.Guest.ToolsStatus -ne "toolsOK" }
        Start-Sleep 1
        # Refresh vmware tools status
        $vms_not_started = $vms_not_started | ForEach-Object { Get-VM -Name $_.Name }
        $timeout -= 1
    }

    $tasks=@()

    $CLI = Get-VM -Name "TF-CLI-$($count.ToString())"
    $vmscript = Get-Content -Path .\CLI.ps1 -Raw | compress | payload -Win
    $tasks += Invoke-VMScript -VM $CLI -ScriptText $vmscript -GuestUser 'user' -GuestPassword 'Pa$$w0rd' -ScriptType Powershell -RunAsync -Confirm:$false

    $SRV = Get-VM -Name "TF-SRV-$($count.ToString())"
    $vmscript = Get-Content -Path .\SRV.ps1 -Raw | compress | payload -Win
    $tasks += Invoke-VMScript -VM $SRV -ScriptText $vmscript -GuestUser 'Administrator' -GuestPassword 'Pa$$w0rd' -ScriptType Powershell -RunAsync -Confirm:$false

    $ISP = Get-VM -Name "TF-ISP-$($count.ToString())"
    $vmscript = Get-Content -Path .\ISP.yaml -Raw | compress | payload -Linux
    $tasks += Invoke-VMScript -VM $ISP -ScriptText $vmscript -GuestUser 'root' -GuestPassword 'toor' -ScriptType Bash -RunAsync -Confirm:$false

    $WEBL = Get-VM -Name "TF-WEB-L-$($count.ToString())"
    $vmscript = Get-Content -Path .\WEBL.yaml -Raw | compress | payload -Linux
    $tasks += Invoke-VMScript -VM $WEBL -ScriptText $vmscript -GuestUser 'root' -GuestPassword 'toor' -ScriptType Bash -RunAsync -Confirm:$false

    $WEBR = Get-VM -Name "TF-WEB-R-$($count.ToString())"
    $vmscript = Get-Content -Path .\WEBR.yaml -Raw | compress | payload -Linux
    $tasks += Invoke-VMScript -VM $WEBR -ScriptText $vmscript -GuestUser 'root' -GuestPassword 'toor' -ScriptType Bash -RunAsync -Confirm:$false

    while ($tasks.State -contains 'running') { Start-Sleep 1 }

    $results = @{ "WEBR_OUT" = $null; "WEBL_OUT" = $null; "CLI_OUT" = $null; "SRV_OUT" = $null; "ISP_OUT" = $null }
    foreach ($task in $tasks) {
        if($task.Result.VM.Name -like "*WEB-L*"){
            $results.WEBL_OUT = ( $task.Result.ScriptOutput.Split("`n") | ConvertFrom-Json )
        }
        elseif ($task.Result.VM.Name -like "*WEB-R*") {
            $results.WEBR_OUT = ( $task.Result.ScriptOutput.Split("`n") | ConvertFrom-Json )
        }
        elseif ($task.Result.VM.Name -like "*SRV*") {
            $results.SRV_OUT = ( $task.Result.ScriptOutput.Split("`n") | ConvertFrom-Json )
        }
        elseif ($task.Result.VM.Name -like "*CLI*") {
            $results.CLI_OUT = ( $task.Result.ScriptOutput.Split("`n") | ConvertFrom-Json )
        }
        elseif ($task.Result.VM.Name -like "*ISP*") {
            $results.ISP_OUT = ( $task.Result.ScriptOutput.Split("`n") | ConvertFrom-Json )
        }
    }

    Get-Marks -results $results | ConvertTo-Json | Out-File -FilePath "D:\Results\$($student).json"
    $count += 1
}

Disconnect-VIServer -Server $vcsa -Confirm:$false
