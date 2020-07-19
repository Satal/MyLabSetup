$hostname = Read-Host -Prompt 'Please specify server name'
$Domain = "mylab.local"

$Credential = Get-Credential

if ($hostname -eq $env:computername) {
    Add-Computer -Domain $Domain -Credential $Credential -Restart -Force
} else {
    Rename-Computer $hostname
    Add-Computer -Domain $Domain -NewName $hostname -Credential $Credential -Restart -Force
}