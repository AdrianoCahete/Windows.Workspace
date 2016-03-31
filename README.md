# Windows.Workspace
My Windows Workspace

This is intended to people who like my workspace, work with me and, more important, me when format or install a new Windows.

This workspace will have some components and PowerShell Scripts to install or update my workspace.

## :warning: WARNING
**This Install isn't tested and isn't complete! Don't run it!**


## PowerShell Profile
**This Profile will replace your profile. Backup and incremetal install are planned.**

### Components
This PowerShell profile contains (and obvious install) some components:
- [Chcolatey](https://chocolatey.org/) - Machine Package Manager, like apt-get, but for Windows.
- [Scoop](http://scoop.sh/) - A command-line installer for Windows
- [ConCfg](https://github.com/lukesampson/concfg) - Import/Export Windows console settings 
- [Pshazz](https://github.com/lukesampson/pshazz) - Pshazz extends your powershell profile
- [PSReadLine](https://github.com/lzybkr/PSReadLine/) -  A bash inspired readline implementation for PowerShell 
- [posh-git](http://dahlbyk.github.io/posh-git/) - A PowerShell environment for Git
- [posh-npm](https://github.com/MSOpenTech/posh-npm) - Powershell-NPM integration 
- If you dont have Powershell 5: [PSGet](http://psget.net/) - Search and install PowerShell modules easy. (PowerShell5 do it natively)

## Scripts
PowerShell profile contains part or full scripts from other sources
- Modified version of [PoshFunctions Powershell Update](https://github.com/kilasuit/PoshFunctions)
- [Wormeyman SourceCode Font Install](https://gist.github.com/wormeyman/9041798) 


## TODO
- Check if PoerShell Window is running with admin privileges
- Backup PowerShell profile first
- Incremental PowerShell Profile
- Remove Scoop requirement for some components
- Install NodeJS
- Install my tools (from npm)