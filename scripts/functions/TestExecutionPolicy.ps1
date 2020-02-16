# TestExecutionPolicy

# Get from Windows.Workspace Repository [ https://github.com/AdrianoCahete/Windows.Workspace ]
# Created by Adriano Cahete [ https://github.com/AdrianoCahete/ ]
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