# 🔌 USB Device Forensics Tracker

## 🚀 Overview
This forensic PowerShell script identifies all USB storage devices ever connected to a Windows system and logs their:
- Device name and serial number
- Manufacturer and friendly name
- Timestamp of connection from event logs

## 🧩 Features
- Pulls registry data from `USBSTOR`
- Extracts device info and vendor metadata
- Searches Windows Event Log for USB connect events (ID 2003)
- Logs findings to `.txt` files with timestamps

## 🛠️ Requirements
- Windows with PowerShell 5+
- Admin permissions (to access registry + Event Logs)

## 📄 Usage

```powershell
cd path\to\USB_Device_Forensics
.\script.ps1
