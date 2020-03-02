# Description: Workspace Install @ Boxstarter
# Author: Adriano Cahete
# This script is based on  @laurentkempe/Cacao [https://github.com/laurentkempe/Cacao/]

# Disable UAC
Disable-UAC

# Get the base path from the ScriptToCall
$bstrappkg = "-bootstrapPackage"

$srcUrl = $Boxstarter['ScriptToCall']
$strpos = $srcUrl.IndexOf($bstrappkg)

$srcUrl = $srcUrl.Substring($strpos + $bstrappkg.Length)
$srcUrl = $srcUrl.TrimStart("'", " ")
$srcUrl = $srcUrl.TrimEnd("'", " ")
$srcUrl = $srcUrl.Substring(0, $srcUrl.LastIndexOf("/"))
$srcUrl += "/functions"
write-host "Helper script base URI is $srcUrl"

function executeScript {
	Param ([string]$script)
	write-host "executing $srcUrl/$script ..."
	iex ((new-object net.webclient).DownloadString("$srcUrl/$script"))
}

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorer.ps1";
executeScript "RemoveDefaultApps.ps1";




######## --- OLD ---
$DocumentsFolder = [Environment]::GetFolderPath("MyDocuments")
$UserProfileFolder = [Environment]::GetFolderPath("UserProfile")
$PSFolder = Join-Path $DocumentsFolder "\WindowsPowerShell"
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent


# Install Powershell Tools
function Install-PowerShellProfile {

	# Get Script Policy 
	$policy = Get-ExecutionPolicy
	if ($policy -ne "Unrestricted") { 
		TestExecutionPolicy
	} else {
		# Start Install
		Write-Output "-----------------------------------------------"
		Write-Output "	PowerShell Profile Installer"
		Write-Output "	  Created by Adriano Cahete`n`n"
		Write-Output "	  github.com/AdrianoCahete"
		Write-Output "-----------------------------------------------"
		Write-Output "		Starting...`n"
	
		# Check if Profile Exists
		Write-Output "[ Check if profile exists... ]"
		if (!(test-path $PROFILE)) {
			# Don"t exist, so create profile 
			Write-Output "`n[ Create and populate Profile ]`n"
			New-Item -path $profile -type file -force
			(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/profile/profile.sample.ps1") > $PSFolder\Microsoft.PowerShell_profile.ps1
			Write-Output "Profile created at $PSFolder\Microsoft.PowerShell_profile.ps1 `nUse 'ii $PSFolder\Microsoft.PowerShell_profile.ps1' to open it"
		} else {
			# Exist, replace profile
			Write-Output "`n[!] Profile already exist. Proceeding install...`n"
			Write-Output "/!\ This script will be replace your currently Powershell Profile!"

			# Replace Profile?
			$profileReplace = Read-Host "[?] Are you sure you want to proceed? [Y] or [N]"
			if ($profileReplace -eq "y" -Or $profileReplace -eq "yes") {
				# Yes
				Write-Output "`n[!] Replacing Profile..."
				# Copy and rename from path\profile\profile.sample.ps1 to $profile 
				(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/profile/profile.sample.ps1") > $PSFolder\Microsoft.PowerShell_profile.ps1
				Write-Output "Profile created at $PSFolder\Microsoft.PowerShell_profile.ps1 `nUse 'ii $PSFolder\Microsoft.PowerShell_profile.ps1' to open it"
			} else {
				# No, i don"t know wtf i"m doing, i need to stop this right now!!!!
				Write-Output "`n/!\ Profile creation has been canceled by user.`nYou'll need to make all changes manually."
				Write-Output "      Profile Sample is opened now..."
				(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/profile/profile.sample.ps1") > $PSFolder\Microsoft.PowerShell_profile.sample.ps1
				ii $PSFolder\Microsoft.PowerShell_profile.sample.ps1
			}
		}
		
		#Install Components
		Write-Output "-----------------`n`n[!] Installing components... (This may take a while)`n"
		
		# Installing Nuget Packet Provider
		#Write-Output "+ Installing Nuget as Package Provider... (This may take a while)"
		Install-PackageProvider -Name NuGet -RequiredVersion "2.8.5.204"
		#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
		
		
		# Install Chcolatey
		$chocoInstalled = choco
		if ("$chocoInstalled" -match "Chocolatey v") {
			Write-Output "[!] Chcolatey is already installed`n"
		}
		else {
			(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
		}
		
		Write-Output "-- Importing Concfg profile..."
		concfg clean
		concfg import --non-interactive https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/components/concfg/concfg_monokai-vs.json
		
		
		# PSReadLine -- https://github.com/lzybkr/PSReadLine/
		Write-Output "`n+ Installing PSReadLine..."
		Write-Output "This will might ask for Nuget as Packet Provider. Please, allow that install."
		Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
		Install-Module PSReadline -Force 
		#"" | Out-File $PROFILE -Append
		
		# posh-git -- https://github.com/dahlbyk/posh-git/
		Write-Output "`n+ Installing posh-git..."
		Install-Module posh-git -Force
		
	
		# Git Credential Manager for-Windows
		Write-Output "`n+ Installing Git Credential Manager..."
		choco install git-credential-manager-for-windows -y
		
		
		Write-Output "`n[!] Install Complete!"
		Write-Output "`n/!\ You need to reload your profile to see changes."
		# Reload Profile?
		$profileReload = Read-Host "[?] Are you sure you want to reload your profile now? [Y] or [N]"
		if ($profileReload -eq "y" -Or $profileReload -eq "yes") {
			# Yes
			Write-Output "`n[!] Reloading Profile... You Powershell will blink some times."
			Start-Sleep -s 5
			.$profile
		} else {
			Write-Output "`n/!\ You need to reload your profile to see changes. You can do it with command below:"
			Write-Output " . $profile"
		}
	}
}
