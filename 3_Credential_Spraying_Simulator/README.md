# 🎯 Credential Spraying Simulator (Ethical)

## 🚀 Overview
This script simulates a credential spray attack by trying a **single password** against multiple usernames in your internal **Active Directory**.

> **WARNING:** This is for internal, ethical use only. Run in lab/test environments unless approved.

## 🧩 Features
- Attempts login via ADSI
- Flags locked out accounts
- Logs results to file
- Simulates real-world Red Team tactics for Blue Team visibility

## 🛠️ Requirements
- PowerShell 5+
- Must be run inside a domain environment
- `usernames.txt` file with one username per line

## 📄 Usage

```powershell
# Example
.\script.ps1 -UserListPath ".\usernames.txt" -Password "Spring2025!"
