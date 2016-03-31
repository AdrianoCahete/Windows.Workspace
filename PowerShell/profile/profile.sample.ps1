#Load PS scripts
$DocumentsFolder = [Environment]::GetFolderPath("MyDocuments")
$psdir= Join-Path $DocumentsFolder "\scripts\autoload"
Get-ChildItem "${psdir}\*.ps1" | %{.$_}

# Data Vars
$Date = Get-Date -Format dd-MM-yyyy
$Time = Get-Date -Format HH:mm

# Colors
# $host.PrivateData.ErrorBackgroundColor = "Black"
# $host.PrivateData.DebugBackgroundColor = "Black"
# $Host.UI.RawUI.BackgroundColor = ($bckgrnd = 'Black')
# $Host.UI.RawUI.ForegroundColor = 'White'
set-psreadlineoption -t parameter darkgreen
set-psreadlineoption -t operator darkgreen
set-psreadlineoption -t string darkgreen

# Set Default Location
set-location c:

# Aliases
# Create your aliases here
#$github = "c:\Github" # Github Folder
#$GitProject = Join-Path $github 'GitProject'

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
	Write-Output "`n[ Running as Administrator ]"
}

# Infos
Write-Host "[ Custom PowerShell Environment Loaded ]`n[ Created by Adriano Cahete - https://github.com/AdrianoCahete/Windows.Workspace ]" 
try { $null = gcm pshazz -ea stop; pshazz init 'monokaivs' } catch { }
