# Tools we expect devs across many scenarios will want
#choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y git-credential-manager-for-windows
choco install -y nvm.portable
choco install -y python
choco install -y kdiff3
choco install -y vscode
choco install -y notepadplusplus
choco install -y fiddler
choco install -y rapidee

# Download and set NodeJS
refreshenv
nvm install 8.17.0
nvm use 8.17.0


# Install-Module -Force oh-my-posh
Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted
refreshenv
Install-Module PSReadLine -AllowPrerelease -Force 
Install-Module Get-ChildItemColor -AllowClobber -Force 
PowerShellGet\Install-Module posh-git -AllowPrerelease -Force
Install-Module z -AllowClobber -Force 
