param(
    [string]$username,
    [string]$password
)
$WarningPreference = 'SilentlyContinue'
# Conversione della password in un oggetto SecureString
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

# Creazione dell'oggetto credenziale
$cred = New-Object System.Management.Automation.PSCredential($username, $securePassword)

# Definizione dell'indirizzo IP del computer remoto
$computerName1 = "192.168.1.12"
$computerName2 = "192.168.1.13"

# Comando da eseguire sul computer remoto
$scriptBlock = {
    # Inserisci qui il comando da eseguire
    # Esempio: Get-Process
    $ActiveNode = (Get-ClusterGroup | Where-Object { $_.Name -eq "ca-dbd28c5d-2c62-49a3-8751-ae6936c604e5" }).OwnerNode.ToString()
    $hostname = hostname
    if ($hostname -eq $ActiveNode) {Get-akshciupdates}
    else { Write-Output "Node Inactive" }
  }

# Esecuzione del comando sul computer remoto
$Host1 = Invoke-Command -ComputerName $computerName1 -ScriptBlock $scriptBlock -Credential $cred
$Host2 = Invoke-Command -ComputerName $computerName2 -ScriptBlock $scriptBlock -Credential $cred

if ($Host1 -eq "") { $Host1 = "No Updates Available" } else { $Host1 = $Host1 }
if ($Host2 -eq "") { $Host1 = "No Updates Available" } else { $Host1 = $Host1 }
Write-output "Host1: $Host1"
Write-output "Host2: $Host2"