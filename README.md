# Windows.Workspace
My Windows Workspace

This is intended to people who like my workspace, work with me and, more important, me when format or install a new Windows.

This workspace will have some components and PowerShell Scripts to install or update my workspace.

## :warning: Notes

- The machine has to be direct access to ```https://raw.githubusercontent.com``` (without autentication process) to download packages
- Install Scripts is just tested with Windows 10 (x64)
- **Create a profile backup beefore run this install**

## Install
To install PowerShell Profile, just need to download and run (as admininistrator) ```PowerShell\Install-PowerShell_Profile.ps1```

You don't need to download all repository, install file download components from here.



## PowerShell Profile
**This Profile will replace your profile. Backup and incremetal install are planned.**

:grey_exclamation: This script needs to change Execution Policy to run and will try to change itself

For more info: https://technet.microsoft.com/pt-br/library/ee176961.aspx

### Components
This PowerShell profile contains (and obvious install) some components:
- [Chcolatey](https://chocolatey.org/) - Machine Package Manager, like apt-get, but for Windows.
- [Scoop](http://scoop.sh/) - A command-line installer for Windows
- [ConCfg](https://github.com/lukesampson/concfg) - Import/Export Windows console settings 
- [Pshazz](https://github.com/lukesampson/pshazz) - Pshazz extends your powershell profile
- [PSReadLine](https://github.com/lzybkr/PSReadLine/) -  A bash inspired readline implementation for PowerShell 
- [posh-git](http://dahlbyk.github.io/posh-git/) - A PowerShell environment for Git
- [posh-npm](https://github.com/MSOpenTech/posh-npm) - Powershell-NPM integration 
- [PSGet](http://psget.net/) - Search and install PowerShell modules easy. (PowerShell5 do it natively)

## Scripts
PowerShell profile contains part or full scripts from other sources
- Modified version of [PoshFunctions Powershell Update](https://github.com/kilasuit/PoshFunctions)
- [Wormeyman SourceCode Font Install](https://gist.github.com/wormeyman/9041798)
- [Check is User has privileges to run (Check is Admin)](https://blogs.technet.microsoft.com/heyscriptingguy/2011/05/11/check-for-admin-credentials-in-a-powershell-script/)

## Aditional Config
~~If you want to configure beyond that configuration, you can edit pshazz profile, concfg and PSProfile itself. I already created a shortcut who'll open that files (before install) in associated editor (for json and ps1 files).~~

Isn't automatized yet, but you can edit alias, colors and all that pshazz using: ```pshazz edit monokaivs```
To edit colors, you can edit concfg using:  ```concfg export``` edit than do ```concfg import``` and edit Porfile Itself

More info, at Components section above.



## TODO
- ~~Check if PowerShell Window is running with admin privileges~~
- ~~Check if anything is already installed and don't do it again~~
- Fix Posh-Git don't working
- Backup PowerShell profile first
- Incremental PowerShell Profile
- Remove Scoop requirement for some components
- Remove PSGet requiremet if PowerShell version if is better or equal 5
- Check and update ExecutionPolicy per User and per Process, separately
- Install NodeJS
- Install my required tools to work (from npm)
- Use [Git Credential Manager](https://github.com/Microsoft/Git-Credential-Manager-for-Windows)
- Automatically confirm Nuget Package Provider install
- Put color in install messages