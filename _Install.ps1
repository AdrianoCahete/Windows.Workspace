# Vars
$Product = "Windows Management Framework 5"
$MinimumFxVersion = "4.5"

$PSVersionMinimum = "3"
$PSVersionExpected = "5"
$PSVersionInstalled = $PSVersionTable.PSVersion.Major

#Write-Verbose "Expected: $PSVersionExpected"
#Write-Verbose "Installed: $PSVersionInstalled"

$DocumentsFolder = [Environment]::GetFolderPath("MyDocuments")
$PSFolder = Join-Path $DocumentsFolder "\WindowsPowerShell"
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent

function Get-FileEncoding($Path) {
    $bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if(!$bytes) { return 'utf8' }

    switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
        '^efbbbf'   { return 'utf8' }
        '^2b2f76'   { return 'utf7' }
        '^fffe'     { return 'unicode' }
        '^feff'     { return 'bigendianunicode' }
        '^0000feff' { return 'utf32' }
        default     { return 'ascii' }
    }
}

if ($PSVersionInstalled -ge $PSVersionMinimum) {

	# Get Script Policy 
	$policy = Get-ExecutionPolicy
	if ($policy -ne 'Unrestricted') { 
		echo "`nBefore running this script, run this command: Set-ExecutionPolicy Unrestricted `nFor more info: https://technet.microsoft.com/pt-br/library/ee176961.aspx"
	} else {

		# Check if Profile Exists
		if (!(test-path $PROFILE)) {
			# Don't exist, so create profile 
			echo "`n[ Create and populate Profile ]`n"
			New-Item -path $profile -type file -force
		} else {
			# Exist, replace profile (TODO: create a backup first)
			echo "`n[ Profile already exist. Proceeding install... ]`n"
			echo "/!\ This script will be replace your currently Powershell Profile!"
			$profileReplace = Read-Host '[?] Are you sure you want to proceed? [Y] or [N]'

			# Replace Profile?
			if ($profileReplace -eq 'y' -Or $profileReplace -eq 'yes') {
				# Yes
				echo "`n[!] Replacing Profile..."
				# Copy from path\profile\myprofile.ps1 to $profile 
			} else {
				# No, i don't know wtf i'm doing, i need to stop this right now!!!!
				echo "`n/!\ Profile creation has been canceled by the user.`nYou'll need to make all changes manually."
			}
		}
		
		#Install Components [TODO: Create an if sequence]
		echo "-----------------`n`n[!] Installing components..."
		
		# Scoop -- http://scoop.sh/
		echo "+ Installing Scoop..."
		iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
		
		# Concfg -- https://github.com/lukesampson/concfg
		echo "`n+ Installing Concfg...`n"
		scoop install concfg
		
		# TODO: Import from path\components\concfg
		echo "-- Importing Concfg profile..."
		concfg import --non-interactive solarized
		
		# Pshazz -- https://github.com/lukesampson/pshazz
		echo "`n+ Installing Pshazz..."
		scoop install pshazz
		echo "-- Getting Pshazz Profile..."
		pshazz get https://raw.github.com/lukesampson/pshazz/master/themes/msys.json
		pshazz use msys
		
		if ($PSVersionInstalled -lt $PSVersionExpected) {
			# PSGet -- http://psget.net/
			echo "`n+ Installing PSGet..."
			(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
			echo "[!] You can find new modules for your Powershell environment here: http://psget.net/directory/"
		}
		
		# PSReadLine -- https://github.com/lzybkr/PSReadLine/
		echo "`n+ Installing PSReadLine..."
		Install-Module PSReadline
		"" | Out-File $PROFILE -Append
		
		# posh-git -- https://github.com/dahlbyk/posh-git/
		echo "`n+ Installing posh-git..."
		Install-Module posh-git
		
		# posh-npm -- https://github.com/MSOpenTech/posh-npm
		echo "`n+ Installing posh-npm..."
		Install-Module posh-npm
		
		# Copy functions to Documents Folder
		
		

		# Reload Profile
		#.$profile
	}
} else {
	# TODO: Update Powershell automatically -- https://raw.githubusercontent.com/kilasuit/PoshFunctions/master/Scripts/Install-WMF5.ps1
	echo "Update your Powershell to latest version."
}