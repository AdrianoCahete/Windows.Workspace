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
function Get-FileEncoding($Path) {
    $bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if(!$bytes) { return "utf8" }

    switch -regex ("{0:x2}{1:x2}{2:x2}{3:x2}" -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
        "^efbbbf"   { return "utf8" }
        "^2b2f76"   { return "utf7" }
        "^fffe"     { return "unicode" }
        "^feff"     { return "bigendianunicode" }
        "^0000feff" { return "utf32" }
        default     { return "ascii" }
    }
}

function TestExecutionPolicy {
	$policy = Get-ExecutionPolicy
	if ($policy -ne "Unrestricted") {

		echo "`n[!] Execution Policy is: $policy`n"
		echo "[!] This script needs to change Execution Policy to run."
		echo "For more info: https://technet.microsoft.com/pt-br/library/ee176961.aspx"
		
		$setExecutionPolice = Read-Host "`n[?] Do you want to proceed? [Y] or [N]`n    If Yes, you'll need to Choose 'Yes For All' two times (for process and for CurrentUser)"
		# Change Execution Policy?
		if ($setExecutionPolice -eq "y" -Or $setExecutionPolice -eq "yes") {
			Set-ExecutionPolicy Unrestricted -Scope Process -Confirm
			Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Confirm
			echo "`n-----------------`n"
			Install-PowerShellProfile
		}
		else {
			echo "`nBefore running this script, run this command: Set-ExecutionPolicy Unrestricted -Scope CurrentUser"
			#echo "`nFor more info: https://technet.microsoft.com/pt-br/library/ee176961.aspx"
			pause
			break
		}
	} else {
		echo "Execution Policy is: $policy`n-----------------`n"
		Install-PowerShellProfile
	}
}

# https://blogs.technet.microsoft.com/heyscriptingguy/2011/05/11/check-for-admin-credentials-in-a-powershell-script/
function checkIsAdmin {
	if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
		pause
		break
    }
}

# https://github.com/kilasuit/PoshFunctions
function UpdatePowerShell {
	[CmdletBinding()]
	param()
	$versionNumber = (Get-WmiObject -class Win32_OperatingSystem |  Select-Object -ExpandProperty version)
	$versionarray = @()
	$versionNumber.Split(".") | ForEach-Object { $versionArray += [int]$_}
	$SimpleVersionNumber = "$($versionArray[0]).$($versionArray[1])"
	
	$caption = (Get-WmiObject -class Win32_OperatingSystem | Select-Object -ExpandProperty Caption)
	$architecture = Get-WmiObject -Class Win32_OperatingSystem |  Select-Object -ExpandProperty OSArchitecture
	
	Write-Verbose "We have Identified your OS and are now determining the Correct package to Download"
	
	If ($SimpleVersionNumber -ge 7) { 
		Write-Warning "WMF 5 is not installable via this method as you are already running Windows10 or Server 2016"
	} else {
		switch ($SimpleVersionNumber) {
			6.3    {$version = "Windows 2012R2/Win8.1"}
			6.2    {$version = "Windows 2012/Win8"}
			6.1    {$version = "Windows 2008R2/Win7"}
		}
	}
	
	if ($version -eq "Windows 2008R2/Win7") {
		if ($caption.contains("Windows 7")) {
			switch ($architecture) {
				"64-bit" {$version = "Windows 7 64Bit"}
				"32-bit" {$version = "Windows 7 32Bit"}
			}
		} else {
			$version = "Windows 2008R2"
		}
	}
	elseif($version -eq "Windows 2012R2/Win8.1") {
		if ($caption.contains("Windows 8.1")) {
			switch ($architecture) {
				"64-bit" {$version = "Windows 8.1 64Bit"}
				"32-bit" {$version = "Windows 8.1 32Bit"}
			}
		}
		else {
			$version = "Windows 2012R2"
		}
	}
	elseif($version -eq "Windows 2012/Win8") {
		if ($caption.contains("Windows 8")) {
			Write-Warning "Windows 8 is not supported for WMF5 - Sorry about that!"
		} else {
			$version = "Windows 2012"
		}
	}  

	switch ($Version) {
		"Windows 2012R2"      {$link = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1AndW2K12R2-KB3134758-x64.msu"}
		"Windows 2012"        {$link = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12-KB3134759-x64.msu"}
		#"Windows 2008R2"      {$link = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu"}    
		"Windows 8.1 64Bit"   {$link = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1AndW2K12R2-KB3134758-x64.msu"}
		"Windows 8.1 32Bit"   {$link = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1-KB3134758-x86.msu"}
		#"Windows 7 64Bit"     {$link = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu"}
		#"Windows 7 32Bit"     {$link = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7-KB3134760-x86.msu"}
	}

	Write-Verbose "We are now downloading the correct version of WMF5 for your System"
	Write-Verbose "System has been Identified as $version"
	$Request = [System.Net.WebRequest]::Create($link)
	$Request.Timeout = "100000000"
	$URL = $Request.GetResponse()
	$Filename = $URL.ResponseUri.OriginalString.Split("/")[-1]
	$url.close()
	
	$WC = New-Object System.Net.WebClient
	$WC.DownloadFile($link,"$env:TEMP\$Filename")
	$WC.Dispose()
	Write-Verbose "We are Installing WMF5 for You"
	Set-Location $env:Temp
	& .\$Filename

	Start-Sleep 80 # IDK why
	Remove-Item "$env:TEMP\$Filename"
	if(Test-path $env:TEMP\WMF4Installed.txt) {
		Remove-Item $env:Temp\installedWMF4.txt
	}
	
	Write-Verbose "You need to Reboot after install of WMF4, so you can now proceed to install WMF5"
	$restartPrompt = Read-Host "[?] Are you sure you want to proceed? [Y] or [N]"
	if ($restartPrompt -eq "y" -Or $restartPrompt -eq "yes") {
			# Yes
			echo "`n[!] Restarting in 5 seconds..."
			shutdown /r /t 5
	} else {
		# No 
		echo "`n/!\ You need to restart manually."
	}
}

function Install-SourceProFont {

	$SourceProFontInstalled = choco list -lo
	if ($SourceProFontInstalled -match "SourceCodePro") {
		echo "[!] SourceCodePro is already installed`n" 
	} else {
		choco install sourcecodepro -y --limitoutput

		# https://gist.github.com/wormeyman/9041798
		Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" #Get the properties of TTF
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" -Name 000 -Value "Source Code Pro" #Set it to SCP
		#Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont" #Check to see if we properly set it so that SCP is an option
	}
}

# Install Powershell Tools
function Install-PowerShellProfile {
	if ($PSVersionInstalled -ge $PSVersionMinimum) {

		# Get Script Policy 
		$policy = Get-ExecutionPolicy
		if ($policy -ne "Unrestricted") { 
			TestExecutionPolicy
		} else {
			# Check if Profile Exists
			if (!(test-path $PROFILE)) {
				# Don"t exist, so create profile 
				echo "`n[ Create and populate Profile ]`n"
				New-Item -path $profile -type file -force
				# Copy from path\profile\profile.sample.ps1 to $profile 
				(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/profile/profile.sample.ps1") > $PSFolder\Microsoft.PowerShell_profile.ps1
			} else {
				# Exist, replace profile
				echo "`n[ Profile already exist. Proceeding install... ]`n"
				echo "/!\ This script will be replace your currently Powershell Profile!"
				$profileReplace = Read-Host "[?] Are you sure you want to proceed? [Y] or [N]"

				# Replace Profile?
				if ($profileReplace -eq "y" -Or $profileReplace -eq "yes") {
					# Yes
					echo "`n[!] Replacing Profile..."
					# Copy and rename from path\profile\profile.sample.ps1 to $profile 
					(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/profile/profile.sample.ps1") > $PSFolder\Microsoft.PowerShell_profile.ps1
				} else {
					# No, i don"t know wtf i"m doing, i need to stop this right now!!!!
					echo "`n/!\ Profile creation has been canceled by user.`nYou'll need to make all changes manually."
					# open Profile and ProfileSample
				}
			}
			
			#Install Components
			echo "-----------------`n`n[!] Installing components... (This may take a while)`n"
			
			# Installing Nuget Packet Provider
			#echo "+ Installing Nuget as Package Provider... (This may take a while)"
			Install-PackageProvider -Name NuGet -RequiredVersion "2.8.5.204"
			#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
			
			
			# Install Chcolatey -- IDK why working like that
			$chocoInstalled = choco
			if (-Not ("$chocoInstalled" -contains "Chocolatey v")) {
				echo "[!] Chcolatey is already installed`n"
			}
			else {
				iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1"))
			}
			
			# Install SourcePro Font
			Install-SourceProFont
			
			
			# Scoop -- http://scoop.sh/
			echo "+ Installing Scoop..."
			iex (new-object net.webclient).downloadstring("https://get.scoop.sh")
			
			
			# Concfg -- https://github.com/lukesampson/concfg
			echo "`n+ Installing Concfg...`n"
			scoop install concfg
			
			# TODO: Import from path\components\concfg
			echo "-- Importing Concfg profile..."
			concfg clean
			concfg import --non-interactive https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/components/concfg/concfg_monokai-vs.json
			
			
			# Pshazz -- https://github.com/lukesampson/pshazz
			echo "`n+ Installing Pshazz..."
			scoop install pshazz
			pshazz init
			
			# Get from Repo
			echo "-- Getting Pshazz Profile..."
			# Get and copy to path
			$pshazzThemeFile = pshazz which microsoft
			$pshazzFolder = Split-Path "$pshazzThemeFile"
			(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/components/pshazz/pshazz_profile.json") > $pshazzFolder\monokaivs.json
			pshazz use monokaivs
			
			
			if ($PSVersionInstalled -lt $PSVersionExpected) {
				# PSGet -- http://psget.net/
				echo "`n+ Installing PSGet..."
				(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
				echo "[!] You can find new modules for your Powershell environment here: http://psget.net/directory/ `nConsider update your Powershell Install"
			}
			
			# PSReadLine -- https://github.com/lzybkr/PSReadLine/
			echo "`n+ Installing PSReadLine..."
			echo "This will might ask for Nuget as Packet Provider. Please, allow that install."
			Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose
			Install-Module PSReadline -Force 
			#"" | Out-File $PROFILE -Append
			
			# posh-git -- https://github.com/dahlbyk/posh-git/
			echo "`n+ Installing posh-git..."
			Install-Module posh-git
			
			# posh-npm -- https://github.com/MSOpenTech/posh-npm
			echo "`n+ Installing posh-npm..."
			Install-Module posh-npm

			
			# Copy functions to Documents Folder
			
			# Reload Profile
			.$profile
		}
	} else {
		$updatePSVersion = Read-Host "[?] Is recommende to update your PowerShell version (actual version is $PSVersionInstalled . This script will update to $PSVersionExpected `n[?] Do you want to proceed? [Y] or [N]"
				
		# Change Execution Policy?
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
