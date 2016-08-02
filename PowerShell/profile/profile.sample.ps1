# Powershell Profile created by Adriano Cahete [ https://github.com/AdrianoCahete/Windows.Workspace ]
# Profile Sample Last Update in 2016-04-01 (Isn't a joke!)

#Load PS scripts
$DocumentsFolder = [Environment]::GetFolderPath("MyDocuments")
$PSdir = Join-Path $DocumentsFolder "\WindowsPowerShell\scripts\autoload"
Get-ChildItem "${PSdir}\*.ps1" | %{.$_}

# Data Vars
$Date = Get-Date -Format dd-MM-yyyy
$Time = Get-Date -Format HH:mm

# Shell Modifications
$Shell = $Host.UI.RawUI

# Colors
$host.PrivateData.ErrorBackgroundColor = "Black"
$host.PrivateData.DebugBackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "White"
$Host.PrivateData.ProgressForegroundColor = "Cyan"
$Host.PrivateData.ProgressBackgroundColor = "Black"
set-psreadlineoption -t parameter darkgreen
set-psreadlineoption -t operator darkgreen
set-psreadlineoption -t string darkgreen

# Window Size
$Shell.WindowSize.width=175
$Shell.WindowSize.height=52

# Set BufferSize
$Shell.BufferSize.width=150
$Shell.BufferSize.height=5000

# Set Default Location
set-location c:\

# Aliases
# Create your aliases here
#$github = "c:\Github" # Github Folder
#$GitProject = Join-Path $github 'GitProject'
#$pshazzThemeFile = pshazz which microsoft
#$pshazzFolder = Split-Path "$pshazzThemeFile"
#$configColors = ii $pshazzFolder\monokaivs.json

# Clear Window
Clear-Host

# ISE
if ($psISE) {
	#Start-Steroids
}

# Data
Write-Output "`n[ $Date @ $Time ]"
$datetime = echo "$Date @ $Time"

# Admin
if ($host.UI.RawUI.WindowTitle -match "Administrador" -Or $host.UI.RawUI.WindowTitle -match "Administrator") {
	Write-Output "`n[ Running as Administrator ]`n"
}

# Infos
Write-Host "[ Custom PowerShell Environment Loaded ]`n[ Created by Adriano Cahete - https://github.com/AdrianoCahete/Windows.Workspace ]`n" 
try { $null = gcm pshazz -ea stop; pshazz init 'monokaivs' } catch { }

#Loads git/npm
#. '$PSdir\profile_posh-git.ps1'
