# Defender_Threat_Hunter/script.ps1

<#
.SYNOPSIS
Threat hunter using Windows Defender CLI and IOC hash matching.

.DESCRIPTION
This script scans local files for known malicious hashes using Windows Defender.
It uses MpCmdRun.exe, logs matches, and sends alert emails if needed.

#>

# === Settings ===
$hashList = @(
    "44d88612fea8a8f36de82e1278abb02f",  # EICAR test file MD5
    "6a204bd89f3c8348afd5c77c717a097a"   # Example malicious hash
)
$logFile = "$PSScriptRoot\scan_results.log"
$emailTo = "security-team@example.com"
$emailFrom = "defender-hunter@example.com"
$smtpServer = "smtp.example.com"

# === Function: Scan Using Defender ===
function Run-DefenderScan {
    Write-Host "`n[+] Running Defender Quick Scan..."
    Start-Process -FilePath "$env:ProgramFiles\Windows Defender\MpCmdRun.exe" -ArgumentList "-Scan -ScanType 1" -Wait
}

# === Function: Check Defender Logs for IOC matches ===
function Get-DefenderDetections {
    Write-Host "[+] Checking Defender logs for matches..."
    $detections = Get-MpThreatDetection
    $matches = $detections | Where-Object { $_.Resources -match ($hashList -join "|") }
    return $matches
}

# === Function: Email Report ===
function Send-AlertEmail {
    param([string]$bodyText)
    Write-Host "[!] Sending alert email to $emailTo"
    Send-MailMessage -To $emailTo -From $emailFrom -SmtpServer $smtpServer -Subject "🚨 Threat Detected by Defender" -Body $bodyText
}

# === Main Execution ===
Run-DefenderScan
Start-Sleep -Seconds 5  # Wait for logs to update
$matches = Get-DefenderDetections

if ($matches) {
    $report = "`n[$(Get-Date)] Threats detected:`n"
    $report += $matches | Format-List | Out-String
    $report | Out-File -FilePath $logFile -Append
    Send-AlertEmail -bodyText $report
    Write-Host "`n[!] ALERT: Threats found and email sent."
} else {
    Write-Host "`n[✓] No known threats found."
    "`n[$(Get-Date)] Scan clean." | Out-File -FilePath $logFile -Append
}

