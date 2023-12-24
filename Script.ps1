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
    Get-akshciupdates
}

# Esecuzione del comando sul computer remoto
Invoke-Command -ComputerName $computerName1 -ScriptBlock $scriptBlock -Credential $cred
Invoke-Command -ComputerName $computerName2 -ScriptBlock $scriptBlock -Credential $cred
