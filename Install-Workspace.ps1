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
#(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/checkIsAdmin.ps1") > $PSFolder\Functions\checkIsAdmin.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/TestExecutionPolicy.ps1") > $PSFolder\Functions\TestExecutionPolicy.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/UpdatePowerShell.ps1") > $PSFolder\Functions\UpdatePowerShell.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/Get-FileEncoding.ps1") > $PSFolder\Functions\Get-FileEncoding.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/Check-WindowsFeature.ps1") > $PSFolder\Functions\Check-WindowsFeature.ps1

# Load Functions 
#. ($PSFolder + '.\Functions\checkIsAdmin.ps1')
. ($PSFolder + '.\Functions\TestExecutionPolicy.ps1')
. ($PSFolder + '.\Functions\UpdatePowerShell.ps1')
. ($PSFolder + '.\Functions\Get-FileEncoding.ps1')
. ($PSFolder + '.\Functions\Check-WindowsFeature.ps1')



# Install Powershell Tools
function Install-Workspace {
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
		
		    #Install Components
		    echo "-----------------`n`n[!] Installing components... (This may take a while)`n"
		
		    # Install Chcolatey
		    $chocoInstalled = choco
		    if ("$chocoInstalled" -match "Chocolatey v") {
			    echo "[!] Chcolatey is already installed`n"
		    }
		    else {
			    (iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
		    }
		
		    # PSReadLine -- https://github.com/lzybkr/PSReadLine/
		    echo "`n+ Installing PSReadLine..."
		    echo "This will might ask for Nuget as Packet Provider. Please, allow that install."
		    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
		    Install-Module PSReadline -Force 
		
		    # posh-git -- https://github.com/dahlbyk/posh-git/
		    echo "`n+ Installing posh-git..."
		    Install-Module posh-git -Force
		
		    # Git Credential Manager for-Windows
		    echo "`n+ Installing Git Credential Manager..."
		    choco install git-credential-manager-for-windows -y
		
		    # NodeJS
		    echo "`n+ Installing NodeJS..."
		    choco install nodejs.install -y
		
		    echo "`n[!] Install Complete!"
	    }
    }
}



If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Install-Workspace
} else {
    Break
}

