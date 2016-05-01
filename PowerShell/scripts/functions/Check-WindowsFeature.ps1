# Get from Windows.Workspace Repository [ https://github.com/AdrianoCahete/Windows.Workspace ]
# Created by Adriano Cahete [ https://github.com/AdrianoCahete/ ]
function Check-WindowsFeature {
	[CmdletBinding()]
    param(
		[Parameter(Position=0,Mandatory=$true)] [string]$FeatureName 
    )
	
	#$FeatureisInstalled = ""

	if((Get-WindowsOptionalFeature -FeatureName $FeatureName -Online) -Like "Enabled") {
		echo "- $FeatureName is enabled"
		#$FeatureisInstalled = "true"
	} else {
		echo "- $FeatureName is disabled"
		echo "[!] Installing $FeatureName now..."
		Enable-WindowsOptionalFeature -FeatureName $FeatureName -Online -NoRestart -All
	}
}