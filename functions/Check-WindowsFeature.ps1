function Check-WindowsFeature {
	[CmdletBinding()]
    param(
		[Parameter(Position=0,Mandatory=$true)] [string]$FeatureName 
    )
	
	#$FeatureisInstalled = ""

	# Thanks jisaak @ http://stackoverflow.com/questions/37352912/how-to-return-true-false-to-get-windowsoptionalfeature-on-windows-10/37353046#37353046
	if((Get-WindowsOptionalFeature -FeatureName $FeatureName -Online).State -eq "Enabled") {
		echo "[!] $FeatureName is Installed"
		#$FeatureisInstalled = "true"
	} else {
		echo "/!\ $FeatureName is disabled"
		echo "[+] Installing $FeatureName now...`n"
		try {
			Enable-WindowsOptionalFeature -FeatureName $FeatureName -Online -NoRestart -All | out-null
			echo "[!] $FeatureName Installed`n-------`n"
		} catch {
			$ErrorMessage = $_.Exception.Message
			$FailedItem = $_.Exception.ItemName
			$Time=Get-Date
			"$FeatureName return an error at ${Time}: $ErrorMessage `n" | out-file c:\Check-WindowsFeaturesInstall.log -append
			echo "$FeatureName Install Error. Please, try to install manually`n"
		}		
	}
}