# Install-NodeJS
# Downloaded from Windows.Workspace Repository [ https://github.com/AdrianoCahete/Windows.Workspace ]
# Created by Adriano Cahete [ https://github.com/AdrianoCahete/ ]


# TODO: Install NVM and install node from there
function Install-NodeJS {
	Install-Package nodejs -ProviderName Chocolatey -ForceBootstrap -Force
    Install-Package npm -ProviderName Chocolatey -ForceBootstrap -Force
}