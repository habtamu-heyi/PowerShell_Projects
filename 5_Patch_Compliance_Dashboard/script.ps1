# Patch_Compliance_Dashboard/script.ps1

<#
.SYNOPSIS
Scans domain computers for missing Windows Updates and generates an HTML report.

.DESCRIPTION
Uses PowerShell remoting and Windows Update APIs to check patch status.
Outputs styled HTML summary showing patch compliance.
#>

$computers = Get-ADComputer -Filter * -Property Name | Select-Object -ExpandProperty Name
$results = @()

Write-Host "`n[+] Starting patch scan for $($computers.Count) domain machines..."

foreach ($comp in $computers) {
    Write-Host "[>] Checking $comp ..."
    try {
        $session = New-PSSession -ComputerName $comp -ErrorAction Stop

        $updates = Invoke-Command -Session $session -ScriptBlock {
            $searcher = New-Object -ComObject Microsoft.Update.Searcher
            $searchResult = $searcher.Search("IsInstalled=0 and Type='Software'")
            return $searchResult.Updates | Select-Object -Property Title, MsrcSeverity
        }

        Remove-PSSession $session

        foreach ($u in $updates) {
            $results += [PSCustomObject]@{
                Computer  = $comp
                Title     = $u.Title
                Severity  = $u.MsrcSeverity
            }
        }
    } catch {
        $results += [PSCustomObject]@{
            Computer = $comp
            Title    = "Connection Failed"
            Severity = "N/A"
        }
    }
}

# === Generate HTML Report ===
$reportFile = "$PSScriptRoot\patch_dashboard.html"

$html = @"
<html>
<head>
  <title>Patch Compliance Report</title>
  <style>
    body { font-family: Arial; background: #f0f0f0; padding: 20px; }
    table { border-collapse: collapse; width: 100%; }
    th, td { padding: 8px 12px; border: 1px solid #ccc; }
    th { background-color: #333; color: #fff; }
    tr:nth-child(even) { background-color: #f9f9f9; }
  </style>
</head>
<body>
  <h2>🛡️ Patch Compliance Report - $(Get-Date)</h2>
  <table>
    <tr><th>Computer</th><th>Update Title</th><th>Severity</th></tr>
"@

foreach ($r in $results) {
    $html += "<tr><td>$($r.Computer)</td><td>$($r.Title)</td><td>$($r.Severity)</td></tr>`n"
}

$html += "</table></body></html>"
$html | Out-File -FilePath $reportFile -Encoding utf8

Write-Host "`n[✓] Report saved to: $reportFile"
