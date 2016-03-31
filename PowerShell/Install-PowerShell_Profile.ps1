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

function TestExecutionPolicy {
	$policy = Get-ExecutionPolicy
	if ($policy -ne 'Unrestricted') {
		#echo "`nBefore running this script, run this command: Set-ExecutionPolicy Unrestricted `nFor more info: https://technet.microsoft.com/pt-br/library/ee176961.aspx"
		Set-ExecutionPolicy Unrestricted -Confirm
	} else {
		echo "Execution Policy is: $policy"
	}
}

# https://github.com/kilasuit/PoshFunctions
function UpdatePowerShell {
	[CmdletBinding()]
	param()
	$versionNumber = (Get-WmiObject -class Win32_OperatingSystem |  Select-Object -ExpandProperty version)
	$versionarray = @()
	$versionNumber.Split('.') | ForEach-Object { $versionArray += [int]$_}
	$SimpleVersionNumber = "$($versionArray[0]).$($versionArray[1])"
	
	$caption = (Get-WmiObject -class Win32_OperatingSystem | Select-Object -ExpandProperty Caption)
	$architecture = Get-WmiObject -Class Win32_OperatingSystem |  Select-Object -ExpandProperty OSArchitecture
	
	Write-Verbose 'We have Identified your OS and are now determining the Correct package to Download'
	
	If ($SimpleVersionNumber -ge 7) { 
		Write-Warning 'WMF 5 is not installable via this method as you are already running Windows10 or Server 2016'
	} else {
		switch ($SimpleVersionNumber) {
			6.3    {$version = "Windows 2012R2/Win8.1"}
			6.2    {$version = "Windows 2012/Win8"}
			6.1    {$version = "Windows 2008R2/Win7"}
		}
	}
	
	if ($version -eq "Windows 2008R2/Win7") {
		if ($caption.contains('Windows 7')) {
			switch ($architecture) {
				'64-bit' {$version = "Windows 7 64Bit"}
				'32-bit' {$version = "Windows 7 32Bit"}
			}
		} else {
			$version = "Windows 2008R2"
		}
	}
	elseif($version -eq "Windows 2012R2/Win8.1") {
		if ($caption.contains('Windows 8.1')) {
			switch ($architecture) {
				'64-bit' {$version = "Windows 8.1 64Bit"}
				'32-bit' {$version = "Windows 8.1 32Bit"}
			}
		}
		else {
			$version = "Windows 2012R2"
		}
	}
	elseif($version -eq "Windows 2012/Win8") {
		if ($caption.contains('Windows 8')) {
			Write-Warning 'Windows 8 is not supported for WMF5 - Sorry about that!'
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

	Write-Verbose 'We are now downloading the correct version of WMF5 for your System'
	Write-Verbose "System has been Identified as $version"
	$Request = [System.Net.WebRequest]::Create($link)
	$Request.Timeout = "100000000"
	$URL = $Request.GetResponse()
	$Filename = $URL.ResponseUri.OriginalString.Split("/")[-1]
	$url.close()
	
	$WC = New-Object System.Net.WebClient
	$WC.DownloadFile($link,"$env:TEMP\$Filename")
	$WC.Dispose()
	Write-Verbose 'We are Installing WMF5 for you'
	Set-Location $env:Temp
	& .\$Filename

	Start-Sleep 80 # IDK why
	Remove-Item "$env:TEMP\$Filename"
	if(Test-path $env:TEMP\WMF4Installed.txt) {
		Remove-Item $env:Temp\installedWMF4.txt
	}
	
	Write-Verbose 'You need to Reboot after install of WMF4, so you can now proceed to install WMF5'
	$restartPrompt = Read-Host '[?] Are you sure you want to proceed? [Y] or [N]'
	if ($restartPrompt -eq 'y' -Or $restartPrompt -eq 'yes') {
			# Yes
			echo "`n[!] Restarting in 5 seconds..."
			shutdown /r /t 5
		} else {
			# No 
			echo "`n/!\ You need to restart manually."
		}
	}
}


function Install-SourceProFont {
	choco install sourcecodepro
	
	# $package = 'SourceCodePro'

	 
	# $fontHelpersPath = (Join-Path (Get-CurrentDirectory) 'FontHelpers.ps1')
	# . $fontHelpersPath
	 
	# $fontUrl = 'https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.zip'
	# $destination = Join-Path $Env:Temp 'SourceCodePro'
	 
	# Install-ChocolateyZipPackage -url $fontUrl -unzipLocation $destination
	 
	# $shell = New-Object -ComObject Shell.Application
	# $fontsFolder = $shell.Namespace(0x14)
	 
	# $fontFiles = Get-ChildItem $destination -Recurse -Filter *.otf
	 
	# # unfortunately the font install process totally ignores shell flags :(
	# # http://social.technet.microsoft.com/Forums/en-IE/winserverpowershell/thread/fcc98ba5-6ce4-466b-a927-bb2cc3851b59
	# # so resort to a nasty hack of compiling some C#, and running as admin instead of just using CopyHere(file, options)
	# $commands = $fontFiles |
	# % { Join-Path $fontsFolder.Self.Path $_.Name } |
	# ? { Test-Path $_ } |
	# % { "Remove-SingleFont '$_' -Force;" }
	 
	# # http://blogs.technet.com/b/deploymentguys/archive/2010/12/04/adding-and-removing-fonts-with-windows-powershell.aspx
	# $fontFiles |
	# % { $commands += "Add-SingleFont '$($_.FullName)';" }
	 
	# $toExecute = ". $fontHelpersPath;" + ($commands -join ';')
	# Start-ChocolateyProcessAsAdmin $toExecute
	 
	# Remove-Item $destination -Recurse

	# https://gist.github.com/wormeyman/9041798
	Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' #Get the properties of TTF
	Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' -Name 000 -Value 'Source Code Pro' #Set it to SCP
	#Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' #Check to see if we properly set it so that SCP is an option
}

if ($PSVersionInstalled -ge $PSVersionMinimum) {

	# Get Script Policy 
	$policy = Get-ExecutionPolicy
	if ($policy -ne 'Unrestricted') { 
		TestExecutionPolicy
	} else {
		# Check if Profile Exists
		if (!(test-path $PROFILE)) {
			# Don't exist, so create profile 
			echo "`n[ Create and populate Profile ]`n"
			New-Item -path $profile -type file -force
			# Copy from path\profile\profile.sample.ps1 to $profile 
		} else {
			# Exist, replace profile
			echo "`n[ Profile already exist. Proceeding install... ]`n"
			echo "/!\ This script will be replace your currently Powershell Profile!"
			$profileReplace = Read-Host '[?] Are you sure you want to proceed? [Y] or [N]'

			# Replace Profile?
			if ($profileReplace -eq 'y' -Or $profileReplace -eq 'yes') {
				# Yes
				echo "`n[!] Replacing Profile..."
				# Copy from path\profile\profile.sample.ps1 to $profile 
			} else {
				# No, i don't know wtf i'm doing, i need to stop this right now!!!!
				echo "`n/!\ Profile creation has been canceled by user.`nYou'll need to make all changes manually."
				# open Profile and ProfileSample
			}
		}
		
		#Install Components
		echo "-----------------`n`n[!] Installing components..."
		
		# Install Chcolatey
		iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
		
		# Install SourcePro Font 
		Install-SourceProFont
		
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
		# Get from Repo
		pshazz get https://raw.github.com/lukesampson/pshazz/master/themes/msys.json
		pshazz use msys
		
		if ($PSVersionInstalled -lt $PSVersionExpected) {
			# PSGet -- http://psget.net/
			echo "`n+ Installing PSGet..."
			(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
			echo "[!] You can find new modules for your Powershell environment here: http://psget.net/directory/ `nConsider update your Powershell Install"
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
		.$profile
	}
} else {
	echo "Updating your Powershell to latest version."
	UpdatePowerShell	
}