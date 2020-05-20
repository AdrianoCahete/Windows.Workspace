# Description: Workspace Install @ Boxstarter
# Author: Adriano Cahete
# This script is based on  @laurentkempe/Cacao [https://github.com/laurentkempe/Cacao/]

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RefreshEnv 
.$profile

# Chocolatey Configs
choco feature enable -n=useRememberedArgumentsForUpgrades
choco feature enable -n=allowGlobalConfirmation

# Install BoxStarter
choco install Boxstarter -y

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
	Invoke-Expression ((new-object net.webclient).DownloadString("$srcUrl/$script"))
}

#--- Setting up Windows ---
executeScript "SystemConfig.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";
executeScript "CommonSofts.ps1";
executeScript "NpmPackages.ps1";
executeScript "PyPackages.ps1";


# Copy PS Profile
# executeScript"ConfigEnv";

# Create Scheduled Tasks
executeScript "ScheduledTasks.ps1";
