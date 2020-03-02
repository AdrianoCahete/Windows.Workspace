
# tools we expect devs across many scenarios will want
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y git-credential-manager-for-windows
choco install -y poshgit
choco install -y kdiff3
choco install -y vscode
choco install -y notepadplusplus
choco install -y fiddler
choco install -y rapidee


# Install-Module -Force oh-my-posh
Install-Module -Force posh-git
Install-Module -Force z
Install-Module -Force Get-ChildItemColor