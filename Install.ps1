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
