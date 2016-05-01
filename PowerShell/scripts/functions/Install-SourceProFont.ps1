# Install-SourceProFont
# Downloaded from Windows.Workspace Repository [ https://github.com/AdrianoCahete/Windows.Workspace ]
# Created by Adriano Cahete [ https://github.com/AdrianoCahete/ ]
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