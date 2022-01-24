$group_name = 'С2018-2'
$json_filename = 'students.json'

$students = $(Get-ADGroupMember $group_name | Get-ADUser ).SamAccountName | Sort-Object
$students | ConvertTo-Json | Out-File -Encoding UTF8 -FilePath $json_filename