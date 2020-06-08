# Tools we expect devs across many scenarios will want
#choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y git-credential-manager-for-windows
choco install -y nvm.portable
choco install -y hub
choco install -y microsoft-windows-terminal
choco install -y python3
choco install -y python2
choco install -y jdk8 # TODO: Add JAVA_HOME to path
choco install -y kdiff3
choco install -y vscode
# TODO: Install visualstudio -- Get parameters
# choco install -y visualstudio2019community --package-parameters "--installPath 'C:\Program Files\VisualStudio\' --allWorkloads --includeRecommended --includeOptional --passive --locale en-US"
choco install -y androidstudio # TODO: Add plataform tools to path: G:\Android\sdk\platform-tools -- Add ANDROID_HOME to path G:\Android\sdk\

choco install -y notepadplusplus
# TODO: Install NotepadReplacer: https://www.binaryfortress.com/NotepadReplacer/FAQ/ -- See comments: https://chocolatey.org/packages/notepadreplacer
choco install -y fiddler
choco install -y postman
choco install -y rapidee # TODO: See if it's still useful
choco install -y openssl # TODO: Add OpenSSL Bin to $env:Path
choco install -y gnupg

# Download and set NodeJS
refreshenv
nvm install 13.11.0
nvm use 13.11.0


# Install-Module -Force oh-my-posh
Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted
refreshenv
Install-Module PSReadLine -AllowPrerelease -Force 
Install-Module Get-ChildItemColor -AllowClobber -Force 
PowerShellGet\Install-Module posh-git -AllowPrerelease -Force
Install-Module z -AllowClobber -Force 
Install-Module -Name windows-screenfetch -Force
