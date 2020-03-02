
# tools we expect devs across many scenarios will want
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y git-credential-manager-for-windows
choco install -y nvm.portable
choco install -y kdiff3
choco install -y vscode
choco install -y notepadplusplus
choco install -y fiddler
choco install -y rapidee


# Install-Module -Force oh-my-posh
Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted
refreshenv
Install-Module PSReadLine -AllowPrerelease -Force 
Install-Module Get-ChildItemColor -AllowClobber -Force 
PowerShellGet\Install-Module posh-git -AllowPrerelease -Force
Install-Module z -AllowClobber -Force 
