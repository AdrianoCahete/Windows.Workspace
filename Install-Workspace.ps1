#requires -version 5
#Requires -RunAsAdministrator


# Script Configs
$NodeVersion = 8.5.0


# Don't change
$PSVersionInstalled = $PSVersionTable.PSVersion.Major
$DocumentsFolder = [Environment]::GetFolderPath("MyDocuments")
$UserProfileFolder = [Environment]::GetFolderPath("UserProfile")
$PSFolder = Join-Path $DocumentsFolder "\WindowsPowerShell"
$PSDefaultParameterValues = @{"*WindowsOptionalFeature:Online"=$true;"*WindowsOptionalFeature:NoRestart"=$true;"*WindowsOptionalFeature:All"=$true}
$OSVersion = [System.Environment]::OSVersion.Version.Major
$OSLanguage = (Get-Culture).Name

Write-Verbose "[ PowerShell Info ]"
Write-Verbose "Installed: $PSVersionInstalled"

# Functions
# Get Functions
mkdir $PSFolder\Functions | Out-Null
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/TestExecutionPolicy.ps1") > $PSFolder\Functions\TestExecutionPolicy.ps1
(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/PowerShell/scripts/functions/Check-WindowsFeature.ps1") > $PSFolder\Functions\Check-WindowsFeature.ps1

# Load Functions 
. ($PSFolder + '.\Functions\TestExecutionPolicy.ps1')
. ($PSFolder + '.\Functions\Check-WindowsFeature.ps1')


# Install Powershell Tools
function Install-Workspace {
	if ($OSVersion -eq 10) {

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
		    if (Get-Command choco) {
			    echo "[!] Chcolatey is already installed`n"
		    }
		    else {
                echo "[!] Chcolatey isn't installed. Installing now...`n"
			    (iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
		    }
		
		    # PSReadLine -- https://github.com/lzybkr/PSReadLine/
		    echo "`n+ Installing PSReadLine..."
		    echo "This will might ask for Nuget as Packet Provider. Please, allow that install."
		    Install-Module PSReadline -Force 
		
		    # posh-git -- https://github.com/dahlbyk/posh-git/
		    echo "`n+ Installing posh-git..."
		    Install-Module posh-git -Force

            # Posh-SSH -- https://github.com/darkoperator/Posh-SSH/
            echo "`n+ Installing posh-ssh..."
            Install-Module -Name Posh-SSH
		
            # Git Credential Manager for-Windows
		    echo "`n+ Installing Git Credential Manager..."
		    choco install git-credential-manager-for-windows -y		    
		
		    # Installing Node 8 ($NodeVersion)
            if(Test-Command nvm) {
                echo "`n+ Installing NodeJS..."
                nvm install $NodeVersion
                nvm use $NodeVersion
            } else {
                choco install nvm -y

                echo "`n[!] You'll need to run nvm install after that.`nnvm install $NodeVersion `nnvm use $NodeVersion"
            }

            # Install Bash if Win10
            Check-WindowsFeature Microsoft-Windows-Subsystem-Linux


            # Check if needs to Install Windows Components
		

		    echo "`n[!] Install Complete!"
	    }
    }
    else {
        echo "This script only works in Widnows 10. If you need a older version, please see the others branches."
    }
}



If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Install-Workspace
} else {
    Break
}

