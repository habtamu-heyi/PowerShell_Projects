# 📊 Patch Compliance Dashboard

## 🚀 Overview
This PowerShell script scans all machines in an Active Directory domain and creates an HTML report showing:
- Missing Windows Updates
- Severity of each patch
- Connection failures for unreachable machines

## 🧩 Features
- Uses PowerShell Remoting and Windows Update COM API
- Logs all machines, including failed ones
- Stylish HTML report for leadership or audits

## 🛠️ Requirements
- Must be run on a domain-joined machine
- Admin access + WinRM enabled on target computers
- Active Directory module installed (`Import-Module ActiveDirectory`)

## 📄 Usage

```powershell
# Run in elevated PowerShell
.\script.ps1



✅ Sample Output

[✓] Report saved to: patch_dashboard.html

📂 HTML Preview
Computer	Update Title	Severity
PC01	Cumulative Update for Win 10 KB503...	Critical
PC02	Connection Failed	N/A

🧠 Pro Tips
Schedule this weekly using Task Scheduler

Email report using Send-MailMessage

Merge with SIEM or compliance system