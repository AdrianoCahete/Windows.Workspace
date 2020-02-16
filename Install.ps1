#requires -version 3.0

$Product = "Windows Management Framework 5"
$MinimumFxVersion = "4.5"

$PSVersionMinimum = "3"
$PSVersionExpected = "5"
$PSVersionInstalled = $PSVersionTable.PSVersion.Major

Write-Verbose "[ PowerShell Info ]"
Write-Verbose "Expected: $PSVersionExpected"
Write-Verbose "Installed: $PSVersionInstalled"

$DocumentsFolder = [Environment]::GetFolderPath("MyDocuments")
$UserProfileFolder = [Environment]::GetFolderPath("UserProfile")
$PSFolder = Join-Path $DocumentsFolder "\WindowsPowerShell"
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent

# Functions
# Get Functions
mkdir $PSFolder\Functions | Out-Null
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/checkIsAdmin.ps1") > $PSFolder\Functions\checkIsAdmin.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/TestExecutionPolicy.ps1") > $PSFolder\Functions\TestExecutionPolicy.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/UpdatePowerShell.ps1") > $PSFolder\Functions\UpdatePowerShell.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/Get-FileEncoding.ps1") > $PSFolder\Functions\Get-FileEncoding.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/Check-WindowsFeature.ps1") > $PSFolder\Functions\Check-WindowsFeature.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/Install-SourceProFont.ps1") > $PSFolder\Functions\Install-SourceProFont.ps1

# Load Functions 
. ($PSFolder + '.\Functions\checkIsAdmin.ps1')
. ($PSFolder + '.\Functions\TestExecutionPolicy.ps1')
. ($PSFolder + '.\Functions\UpdatePowerShell.ps1')
. ($PSFolder + '.\Functions\Get-FileEncoding.ps1')
. ($PSFolder + '.\Functions\Check-WindowsFeature.ps1')
#. ($PSFolder + '.\Functions\Install-SourceProFont.ps1')



# Install Powershell Tools
function Install-PowerShellProfile {
	if ($PSVersionInstalled -ge $PSVersionMinimum) {

		# Get Script Policy 
		$policy = Get-ExecutionPolicy
		if ($policy -ne "Unrestricted") { 
			TestExecutionPolicy
		} else {
			# Start Install
			echo "-----------------------------------------------"
			echo "	PowerShell Profile Installer"
			echo "	  Created by Adriano Cahete`n`n"
			echo "	  github.com/AdrianoCahete"
			echo "-----------------------------------------------"
			echo "		Starting...`n"
		
			# Check if Profile Exists
			echo "[ Check if profile exists... ]"
			if (!(test-path $PROFILE)) {
				# Don"t exist, so create profile 
				echo "`n[ Create and populate Profile ]`n"
				New-Item -path $profile -type file -force
				(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/profile/profile.sample.ps1") > $PSFolder\Microsoft.PowerShell_profile.ps1
				echo "Profile created at $PSFolder\Microsoft.PowerShell_profile.ps1 `nUse 'ii $PSFolder\Microsoft.PowerShell_profile.ps1' to open it"
			} else {
				# Exist, replace profile
				echo "`n[!] Profile already exist. Proceeding install...`n"
				echo "/!\ This script will be replace your currently Powershell Profile!"

				# Replace Profile?
				$profileReplace = Read-Host "[?] Are you sure you want to proceed? [Y] or [N]"
				if ($profileReplace -eq "y" -Or $profileReplace -eq "yes") {
					# Yes
					echo "`n[!] Replacing Profile..."
					# Copy and rename from path\profile\profile.sample.ps1 to $profile 
					(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/profile/profile.sample.ps1") > $PSFolder\Microsoft.PowerShell_profile.ps1
					echo "Profile created at $PSFolder\Microsoft.PowerShell_profile.ps1 `nUse 'ii $PSFolder\Microsoft.PowerShell_profile.ps1' to open it"
				} else {
					# No, i don"t know wtf i"m doing, i need to stop this right now!!!!
					echo "`n/!\ Profile creation has been canceled by user.`nYou'll need to make all changes manually."
					echo "      Profile Sample is opened now..."
					(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/profile/profile.sample.ps1") > $PSFolder\Microsoft.PowerShell_profile.sample.ps1
					ii $PSFolder\Microsoft.PowerShell_profile.sample.ps1
				}
			}
			
			#Install Components
			echo "-----------------`n`n[!] Installing components... (This may take a while)`n"
			
			# Installing Nuget Packet Provider
			#echo "+ Installing Nuget as Package Provider... (This may take a while)"
			Install-PackageProvider -Name NuGet -RequiredVersion "2.8.5.204"
			#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
			
			
			# Install Chcolatey
			$chocoInstalled = choco
			if ("$chocoInstalled" -match "Chocolatey v") {
				echo "[!] Chcolatey is already installed`n"
			}
			else {
				(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
			}
			
			# Install SourcePro Font
			#Install-SourceProFont
			
			
			# Scoop -- http://scoop.sh/
			$scoopInstalled = scoop status
			if ("$scoopInstalled" -match "up-to-date") {
				echo "[!] Scoop is already installed`n"
			}
			elseif ("$scoopInstalled" -match "out of date") {
				# Updating
				echo "[!] Updating Scoop...`n"
				scoop update
			}
			else {
				echo "+ Installing Scoop..."
				iex (new-object net.webclient).downloadstring("https://get.scoop.sh")
			}
			
			
			# Concfg -- https://github.com/lukesampson/concfg
			$scoopInstalledConcfg = scoop list
			if ("$scoopInstalledConcfg" -match "concfg") {
				echo "[!] Concfg is already installed`n"
			}
			else {
				echo "`n+ Installing Concfg...`n"
				scoop install concfg
			}
			
			echo "-- Importing Concfg profile..."
			concfg clean
			concfg import --non-interactive https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/components/concfg/concfg_monokai-vs.json
			
			
			# Pshazz -- https://github.com/lukesampson/pshazz
			$scoopInstalledpshazz = scoop list
			if ("$scoopInstalledpshazz" -match "pshazz") {
				echo "`n[!] Pshazz is already installed`n"
			}
			else {
				echo "`n+ Installing Pshazz..."
				scoop install pshazz
				pshazz init
			}
			
			# Get from Repo
			echo "-- Getting Pshazz Profile..."
			# Get and copy to path
			$pshazzThemeFile = pshazz which microsoft
			$pshazzFolder = Split-Path "$pshazzThemeFile"
			(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/components/pshazz/pshazz_profile.json") > $pshazzFolder\monokaivs.json
			pshazz use monokaivs
			
			
			#if ($PSVersionInstalled -lt $PSVersionExpected) {
				# PSGet -- http://psget.net/
				echo "`n+ Installing PSGet..."
				(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
				echo "`n[!] You can find new modules for your Powershell environment here: http://psget.net/directory/"
				#echo "Consider update your Powershell Install`n"
			#}
			
			# PSReadLine -- https://github.com/lzybkr/PSReadLine/
			echo "`n+ Installing PSReadLine..."
			echo "This will might ask for Nuget as Packet Provider. Please, allow that install."
			Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
			Install-Module PSReadline -Force 
			#"" | Out-File $PROFILE -Append
			
			# posh-git -- https://github.com/dahlbyk/posh-git/
			echo "`n+ Installing posh-git..."
			Install-Module posh-git -Force
			
			# posh-npm -- https://github.com/MSOpenTech/posh-npm
			# Didn't Install because https://github.com/MSOpenTech/posh-npm/issues/1
			echo "`n+ Installing posh-npm..."
			Install-Module posh-npm -Force
			
			# Git Credential Manager for-Windows
			echo "`n+ Installing Git Credential Manager..."
			choco install git-credential-manager-for-windows -y
			
			# NodeJS
			echo "`n+ Installing NodeJS..."
			choco install nodejs.install -y
			
			# Fixing PSRepository 
			Set-PSRepository -Name PSGallery -PackageManagementProvider NuGet -InstallationPolicy Trusted -SourceLocation "https://www.powershellgallery.com/api/v2/"

			
			# Copy functions to Documents Folder
			echo "`n+ Copy Functions..."
			
			# posh-git 
			if (Test-Path $PSFolder\scripts\autoload\profile_posh-git.ps1) {
				echo "`n[!] PoshGit is already loaded"
			} else {
				mkdir $PSFolder\scripts\autoload\
				(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/autoload/profile_posh-git.ps1") > $PSFolder\scripts\autoload\profile_posh-git.ps1
				#"" | Out-File $PROFILE -Append
			}
			
			# posh-npm
			if (Test-Path $PSFolder\scripts\autoload\profile_posh-npm.ps1) {
				echo "`n[!] PoshNPM is already loaded"
			} else {
				#mkdir $PSFolder\scripts\autoload\
				(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/autoload/profile_posh-npm.ps1") > $PSFolder\scripts\autoload\profile_posh-npm.ps1
			}
			
			echo "`n[!] Install Complete!"
			echo "`n/!\ You need to reload your profile to see changes."
			# Reload Profile?
			$profileReload = Read-Host "[?] Are you sure you want to reload your profile now? [Y] or [N]"
			if ($profileReload -eq "y" -Or $profileReload -eq "yes") {
				# Yes
				echo "`n[!] Reloading Profile... You Powershell will blink some times."
				Start-Sleep -s 5
				.$profile
			} else {
				echo "`n/!\ You need to reload your profile to see changes. You can do it with command below:"
				echo " . $profile"
			}
		}
	} else {
		$updatePSVersion = Read-Host "[?] Is recommended to update your PowerShell version (actual version is $PSVersionInstalled . This script will update to $PSVersionExpected `n[?] Do you want to proceed? [Y] or [N]"
				
		# Update PS Version?
		if ($updatePSVersion -eq "y" -Or $updatePSVersion -eq "yes") {
			echo "Updating your Powershell to latest version."
			UpdatePowerShell
		}
		else {
			echo "`nYou need to update yout PowerShell to latest version."
		}	
	}
}

$admincheck = checkIsAdmin
If (-Not ($admincheck)) {
	Install-PowerShellProfile
} else {
	Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
}
