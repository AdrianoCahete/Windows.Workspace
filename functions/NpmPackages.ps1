# Check-NpmPackage

# Downloaded from Windows.Workspace Repository [ https://github.com/AdrianoCahete/Windows.Workspace ]
# Created by Adriano Cahete [ https://github.com/AdrianoCahete/ ]
function Check-NpmPackage {
	[CmdletBinding()]
    param(
		[Parameter(Position=0,Mandatory=$true)] [string]$PackageName		
    )
	
	#$FeatureisInstalled = ""

	if((npm list -g -depth=0) -Like $PackageName) {
		echo "- $PackageName is enabled"
		#$FeatureisInstalled = "true"
	} else {
		echo "- $PackageName isn't installed"
		echo "[!] Installing $PackageName now..."
		#npm install $PackageName
	}
}
