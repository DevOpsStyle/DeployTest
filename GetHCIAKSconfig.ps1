param(
    [string]$username,
    [string]$password
)

$WarningPreference = 'SilentlyContinue'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $securePassword)

$computerName1 = "192.168.1.12"
$computerName2 = "192.168.1.13"

$scriptBlock = {
    $ActiveNode = (Get-ClusterGroup | Where-Object { $_.Name -eq "ca-dbd28c5d-2c62-49a3-8751-ae6936c604e5" }).OwnerNode.ToString()
    $hostname = hostname
    if ($hostname -eq $ActiveNode) 
    { Get-akshcicluster | ft | out-string } 
    else 
    { Write-Output "Node Inactive" }
}

$maxAttempts = 3  # Numero massimo di tentativi
$attempt = 0

function Invoke-RemoteCommand {
    param(
        [string]$computerName,
        [scriptblock]$scriptBlock,
        [pscredential]$cred
    )

    $result = $null
    $success = $false

    while (-not $success -and ($attempt -lt $maxAttempts)) {
        $attempt++
        try {
            $result = Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock -Credential $cred -ErrorAction Stop
            $success = $true
        } catch {
            Write-Output "Tentativo $attempt fallito su $computerName. Riprovo..."
        }
    }

    return $result
}

$Host1 = Invoke-RemoteCommand -computerName $computerName1 -scriptBlock $scriptBlock -cred $cred
$Host2 = Invoke-RemoteCommand -computerName $computerName2 -scriptBlock $scriptBlock -cred $cred

Write-output "Host1: $Host1" | out-file -filepath C:\temp\configresult.txt -append
Write-output "----------------" | out-file -filepath C:\temp\configresult.txt -append
Write-output "Host2: $Host2" | out-file -filepath C:\temp\configresult.txt -append
