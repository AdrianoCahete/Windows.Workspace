# Windows.Workspace
My Windows Workspace

This is intended to people who like my workspace, work with me and, more important, me when format or install a new Windows.

This workspace will have some components and PowerShell Scripts to install or update my workspace.

![PowerShell example Image](https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/imgs/ps_example.PNG)

Colors can be edited with ```pshazz edit monokaivs``` command

--

![PowerShell example Image](https://raw.githubusercontent.com/AdrianoCahete/Windows.Workspace/master/imgs/wincred.PNG)

## :warning: Notes

- The machine has to be direct access to ```https://raw.githubusercontent.com``` (without autentication process) to download packages
- Install Scripts is just tested with Windows 10 (x64) and Windows 8.1 (x64)
- **Create a profile backup before run this install**

## Install
To install PowerShell Profile, just need to download and run (as admininistrator) ```PowerShell\Install-PowerShell_Profile.ps1```

You don't need to download all repository, install file download components from here.



## PowerShell Profile
**This Profile will replace your profile. Backup and incremetal install are planned.**

:grey_exclamation: This script needs to change Execution Policy to run and will try to change itself.

Or you can run this command before: ```Set-ExecutionPolicy Unrestricted -Confirm```

For more info: https://technet.microsoft.com/pt-br/library/ee176961.aspx

### Components
This PowerShell profile contains (and obvious install) some components:
- [Chcolatey](https://chocolatey.org/) - Machine Package Manager, like apt-get, but for Windows.
- [NodeJE](http://nodejs.org//) - Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine.
- [Git Credential Manager](https://github.com/Microsoft/Git-Credential-Manager-for-Windows) - Secure Git credential storage for Windows. 
- [Scoop](http://scoop.sh/) - A command-line installer for Windows
- [ConCfg](https://github.com/lukesampson/concfg) - Import/Export Windows console settings 
- [Pshazz](https://github.com/lukesampson/pshazz) - Pshazz extends your powershell profile
- [PSReadLine](https://github.com/lzybkr/PSReadLine/) -  A bash inspired readline implementation for PowerShell 
- [posh-git](http://dahlbyk.github.io/posh-git/) - A PowerShell environment for Git
- [posh-npm](https://github.com/MSOpenTech/posh-npm) - Powershell-NPM integration 
- [PSGet](http://psget.net/) - Search and install PowerShell modules easy. (PowerShell5 do it natively)

#### Tools
This script add some handy tools, like [z](https://github.com/JannesMeyer/z.ps). 

z is a "utility to jump to your favorite directories".

You just need to type "z" on PowerShell console to see the magic. You can see all the commands [here](https://github.com/JannesMeyer/z.ps#usage)


## Scripts
PowerShell profile contains part or full scripts from other sources
- Modified version of [PoshFunctions Powershell Update](https://github.com/kilasuit/PoshFunctions)
- ~~[Wormeyman SourceCode Font Install](https://gist.github.com/wormeyman/9041798)~~ # Disabled for now (2016-05-01)
- [Check is User has privileges to run (Check is Admin)](https://blogs.technet.microsoft.com/heyscriptingguy/2011/05/11/check-for-admin-credentials-in-a-powershell-script/)

## Functions
Now, this repo has access to functions, separately. You can get and use (giving me and/or the people who created the function credit).

You just need to get in Functions folder.

Avaliable Functions are:
- CheckIsAdmin (see above);
- TestExecutionPolice (Test the user or process about Execution Police)
- UpdatePowerShell (Update PowerShell Environment to PS5)
- Get-FileEncoding (Get enconding from file)
- Check-WindowsFeature (Check for a Windows Feature, if don't installed, script will install itself)
- Install-SourceProFont (Install SourcePro Font)

The following functions are not yet complete or tested, so the use is not recommended:
- InstallNode
- NpmPackages



## Aditional Config
~~If you want to configure beyond that configuration, you can edit pshazz profile, concfg and PSProfile itself. I already created a shortcut who'll open that files (before install) in associated editor (for json and ps1 files).~~

Isn't automatized yet, but you can edit alias, colors and all that pshazz using: ```pshazz edit monokaivs```
To edit colors, you can edit concfg using:  ```concfg export``` edit than do ```concfg import``` and edit Porfile Itself

More info, at [Components](#components) section above.



## TODO
- ~~Check if PowerShell Window is running with admin privileges~~
- ~~Check if anything is already installed and don't do it again~~
- ~~Fix Posh-Git don't working~~
- ~~Use [Git Credential Manager](https://github.com/Microsoft/Git-Credential-Manager-for-Windows)~~
- ~~Install NodeJS~~
- ~~Separate functions for external use~~


- Backup PowerShell profile first
- Incremental PowerShell Profile
- Remove Scoop requirement for some components
- Remove PSGet requirement if PowerShell version if is better or equal 5
- Check and update ExecutionPolicy per User and per Process, separately
- Standardize echo with Write-Verbose/Write-progress
- Install my required tools to work (from npm)
- Automatically confirm Nuget Package Provider install
- Put color in install messages