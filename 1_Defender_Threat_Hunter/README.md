# 🛡️ Defender Threat Hunter

## 🚀 Overview
This PowerShell script is a lightweight threat hunting tool that:
- Runs a Windows Defender quick scan
- Compares system detections to a known list of IOC hashes
- Sends email alerts with logs if a match is found

## 🧩 Features
- Uses built-in `MpCmdRun.exe` for real scanning
- IOC hash matching (MD5/SHA1/SHA256)
- Sends alerts to SOC/Blue Team email
- Logs findings to a local file

## 🛠️ Requirements
- Windows 10/11 or Server with Windows Defender installed
- PowerShell 5+
- Internet access for sending email alerts (SMTP)

## 📄 Usage

```powershell
cd path\to\Defender_Threat_Hunter
.\script.ps1

📬 Email Setup
Update these variables in the script:

powershell
Copy
Edit
$emailTo = "security-team@example.com"
$emailFrom = "defender-hunter@example.com"
$smtpServer = "smtp.example.com"

✅ Sample Output
css
Copy
Edit
[+] Running Defender Quick Scan...
[+] Checking Defender logs for matches...
[✓] No known threats found.

🧠 Pro Tips
Schedule this via Task Scheduler to run daily

Extend it with VirusTotal or IPinfo API

Integrate into SIEM pipeline via log forwarding
