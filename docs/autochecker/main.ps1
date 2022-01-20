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

$vcsa = "vcsacluster.ouiit.local"
Connect-VIServer -Server $vcsa

$CLI = Get-VM -Name "TF-CLI-0"
$vmscript = Get-Content -Path .\CLI.ps1 -Raw | compress | payload -Win
$out = Invoke-VMScript -VM $CLI -ScriptText $vmscript -GuestUser 'user' -GuestPassword 'Pa$$w0rd' -ScriptType Powershell
$CLI_OUT = $out.ScriptOutput | ConvertFrom-Json

##################

$SRV = Get-VM -Name "TF-SRV-0"
$vmscript = Get-Content -Path .\SRV.ps1 -Raw | compress | payload -Win
$out = Invoke-VMScript -VM $SRV -ScriptText $vmscript -GuestUser 'Administrator' -GuestPassword 'Pa$$w0rd' -ScriptType Powershell
$SRV_OUT = $out.ScriptOutput | ConvertFrom-Json

##################

$ISP = Get-VM -Name "TF-ISP-0"
$vmscript = Get-Content -Path .\ISP.yaml -Raw | compress | payload -Linux
$out = Invoke-VMScript -VM $ISP -ScriptText $vmscript -GuestUser 'root' -GuestPassword 'toor' -ScriptType Bash
$ISP_OUT = $out.ScriptOutput | ConvertFrom-Json

###################

$WEBL = Get-VM -Name "TF-WEB-L-0"
$vmscript = Get-Content -Path .\WEBL.yaml -Raw | compress | payload -Linux
$out = Invoke-VMScript -VM $WEBL -ScriptText $vmscript -GuestUser 'root' -GuestPassword 'toor' -ScriptType Bash
$WEBL_OUT = $out.ScriptOutput | ConvertFrom-Json

###################

$WEBR = Get-VM -Name "TF-WEB-R-0"
$vmscript = Get-Content -Path .\WEBR.yaml -Raw | compress | payload -Linux
$out = Invoke-VMScript -VM $WEBR -ScriptText $vmscript -GuestUser 'root' -GuestPassword 'toor' -ScriptType Bash
$WEBR_OUT = $out.ScriptOutput | ConvertFrom-Json

#####################################

$CLI_OUT
$SRV_OUT
$ISP_OUT
$WEBL_OUT
$WEBR_OUT

$result = @(
    [pscustomobject]@{
        "Name" = "CLI: Basic configuration"; "Max" = 0.3; "Mark" = if($CLI.hostname -and $CLI.netconf){ 0.3 }else{0}
    },
    [pscustomobject]@{
        "Name" = "SRV: Basic configuration"; "Max" = 0.3; "Mark" = if($SRV.hostname -and $SRV.netconf){ 0.3 }else{0}
    },
    [pscustomobject]@{
        "Name" = "ISP: Basic configuration"; "Max" = 0.3; "Mark" = if($ISP.hostname -and $ISP.ens192 -and $ISP.ens224 -and $ISP.ens256){ 0.3 }else{0}
    },
    [pscustomobject]@{
        "Name" = "WEB-L: Basic configuration"; "Max" = 0.3; "Mark" = if($WEBL.hostname -and $WEBL.ens192){ 0.3 }else{0}
    },
    [pscustomobject]@{
        "Name" = "WEB-R: Basic configuration"; "Max" = 0.3; "Mark" = if($WEBR.hostname -and $WEBR.ens192){ 0.3 }else{0}
    }
)
$result | Format-Table

Disconnect-VIServer -Server $vcsa -Confirm:$false
