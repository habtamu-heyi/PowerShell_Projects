# 🌐 Network Port Scanner + Banner Grabber

## 🚀 Overview
This PowerShell script is a basic TCP port scanner that:
- Detects open ports on a given host
- Attempts to grab service banners (e.g., from HTTP, FTP, SSH)
- Helps identify potential vulnerabilities or misconfigured services

## 🧩 Features
- Scans any IP address
- Adjustable port range
- Banner grabbing logic via raw TCP stream
- Timeout handling for responsiveness

## 🛠️ Requirements
- Windows with PowerShell 5+
- No external modules required

## 📄 Usage

```powershell
.\script.ps1 -TargetIP "192.168.1.10" -Ports 21,22,80,443


Or scan a whole range:

.\script.ps1 -TargetIP "192.168.1.10" -Ports (1..1024)

[+] Scanning 192.168.1.10 on ports 21 to 1024...

[✓] Open port: 22
    Banner: SSH-2.0-OpenSSH_7.4

[✓] Open port: 80
    Banner: HTTP/1.1 400 Bad Request

[✓] Open port: 443
    No banner received.

[✓] Scan complete.



🔍 Use Cases
Network Reconnaissance

Penetration Test Prep

Internal Vulnerability Sweeps

🧠 Pro Tip
Compare banner data with CVE database

Use with Resolve-DnsName for domain targets

Extend with JSON output for report pipelines