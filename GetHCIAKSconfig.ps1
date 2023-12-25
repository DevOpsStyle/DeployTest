param(
    [string]$username,
    [string]$password
)

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
    Get-akshcicluster
}

# Esecuzione del comando sul computer remoto
$Host1 = Invoke-Command -ComputerName $computerName1 -ScriptBlock $scriptBlock -Credential $cred
$Host2 = Invoke-Command -ComputerName $computerName2 -ScriptBlock $scriptBlock -Credential $cred

Write-output "Host1: $Host1\n---------------\nHost2: $Host2"