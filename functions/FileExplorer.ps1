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
