#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

#--- Configuring Windows properties ---
#--- Windows Features ---
# Show hidden files,  Show file extensions, Hide Frequent Folders, Hide Recent Files, Show Ribbon
Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowRibbon -DisableShowRecentFilesInQuickAccess -DisableShowFrequentFoldersInQuickAccess

#--- File Explorer Settings ---
# Will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1

# Opens PC to This PC, not quick access
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1

# Taskbar where window is open for multi-monitor
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarEnabled  -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

#--- Enable Clpiboard History
Set-ItemProperty -Path HKCU:\Software\Microsoft\Clipboard -Name EnableClipboardHistory -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Clipboard -Name ShellHotKeyUsed -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Clipboard -Name PastedFromClipboardUI -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Clipboard -Name ClipboardTipRequired -Value 0

#--- Hide Cortana Button on the Taskbar
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0

#--- Remove Search button
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0

#--- Remove People button
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -Value 0

#--- Install NVidia Display Driver
choco install nvidia-display-driver -y

# Update PowerShell Helps
Update-Help

# Refresh Environment
refreshenv