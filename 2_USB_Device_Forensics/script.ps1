# USB_Device_Forensics/script.ps1

<#
.SYNOPSIS
Tracks USB storage device connection history using Registry and Event Logs.

.DESCRIPTION
Parses the SYSTEM hive to get USB serials, vendors, and correlates them with
timestamps from the Windows Event Log.
#>

$usbList = @()
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"

# === Collect USB device details ===
Write-Host "`n[+] Gathering USB storage info from registry..."
Get-ChildItem $regPath | ForEach-Object {
    $deviceKey = $_
    Get-ChildItem $deviceKey.PSPath | ForEach-Object {
        $subkey = $_
        $properties = Get-ItemProperty $subkey.PSPath
        $info = [PSCustomObject]@{
            DeviceName = $deviceKey.PSChildName
            Serial     = $subkey.PSChildName
            Friendly   = $properties.FriendlyName
            Mfg        = $properties.Mfg
        }
        $usbList += $info
    }
}

# === Try correlating with Event Logs (Event ID 2003 or 2100 for USB connect) ===
Write-Host "[+] Searching Event Logs for USB connection events..."
$events = Get-WinEvent -FilterHashtable @{
    LogName='Microsoft-Windows-DriverFrameworks-UserMode/Operational';
    ID=2003
} -ErrorAction SilentlyContinue | Select-Object TimeCreated, Message -First 20

# === Output results ===
Write-Host "`n--- USB Devices Found ---"
$usbList | Format-Table -AutoSize

Write-Host "`n--- Recent USB Connection Events ---"
$events | Format-Table TimeCreated, Message -Wrap -AutoSize

# === Save to log file ===
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$usbList | Out-File "usb_devices_$timestamp.txt"
$events | Out-File "usb_events_$timestamp.txt"

Write-Host "`n[✓] Logs saved successfully."
