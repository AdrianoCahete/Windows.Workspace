# Windows.Workspace

> This `master` branch doesn't fully tested.

This is intended to me when I install a new Windows instance (and for people who like my workspace or work with me).

This repository have some components and PowerShell Scripts to install my workspace, using Chocolatey and Winget


## :warning: Requirements
- The machine has to have direct access to `https://raw.githubusercontent.com` (without authentication process) to download packages
- Install Scripts is just tested with Windows 10 (x64)
- **Create a profile backup before run this install**


## Install
For now, you just need to download the repository as a zip and run `Install.ps1` at root.


## PowerShell Profile
**This Profile will replace your profile. Backup and incremental install are planned.**

:grey_exclamation: This script may need to change Execution Policy to run

Or you can run this command before:  
`Set-ExecutionPolicy Unrestricted -Confirm`

For more info: https://technet.microsoft.com/pt-br/library/ee176961.aspx


### Windows Configs
This Install file does the follow changes in windows:
- Disables UAC
- Change some Windows Explorer definitions, as:
    - Show File Extensions
    - Always show Explorer Ribbon
    - Hide "Recent files" in Quick Access
    - Hide "Frequent folders" in Quick Access
    - Enable Expand folder in Explorer sidebar (will expand explorer to the actual folder you're in)
    - Opens by default to "My Computer" instead of "Quick Access"
    - Configure Taskbar to show the programs only in the screen that the program is open (Multi monitor support)
    - Enable Clipboard History
    - Hide Cortana button in Taskbar
    - Hide Search button in Taskbar
    - Hide People button in Taskbar
- Install latest NVidia Driver
- Update Helps
- Install the follow components and tools

### Components
This PowerShell profile contains (and obvious install) some components:
- Boxstarter
- [Chocolatey](https://chocolatey.org/) - Machine Package Manager, like apt-get, but for Windows.
- [Winget](#) - Windows Package Manager, like apt-get, but for Windows (and official).
- [NodeJS](http://nodejs.org//) - Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine.
- [Git Credential Manager](https://github.com/Microsoft/Git-Credential-Manager-for-Windows) - Secure Git credential storage for Windows. 
- [PSReadLine](https://github.com/lzybkr/PSReadLine/) -  A bash inspired readline implementation for PowerShell 
- [posh-git](http://dahlbyk.github.io/posh-git/) - A PowerShell environment for Git
- Get-ChildItemColor
- [z](https://github.com/JannesMeyer/z.ps) is a "utility to jump to your favorite directories".  
    You just need to type "z" on PowerShell console to see the magic. You can see all the commands [here](https://github.com/JannesMeyer/z.ps#usage)
- NodeJS 13.11
- Android Studio
- Hub
- Microsoft Windows Terminal
- Python 2 and 3
- JDK8
- kdiff3
- Visual Studio Code
- Notepad++
- Fiddler
- Postman
- Rapidee
- OpenSSL
- Gnupg
- Windows Screenfetch
- VLC
- Evernote
- Treesizefree
- K-Lite Codec Pack (Mega)


#### Browsers
- Firefox
- Google Chrome
- Microsoft Edge (Chromium based)

#### NPM Global Packages
- Google Lighthouse
- Lighthouse-badges
- gitignore
- boilerplate-creator
- react-native-cli
- npm-check

#### Python Packages
- Youtube_DL
- SCDL

### Windows Default Applications
This scrip will try to remove the follow default installed Windows programs too.

- "Microsoft.3DBuilder"
- "Microsoft.BingNews"
- "Microsoft.BingSports"
- "Microsoft.Getstarted"
- "March of Empires"
- "Microsoft.GetHelp"
- "Microsoft.Messaging"
- "Minecraft"
- "Microsoft.MicrosoftOfficeHub"
- "Microsoft.OneConnect"
- "Microsoft.MicrosoftStickyNotes"
- "Microsoft.Office.Sway"
- "Microsoft.NetworkSpeedTest"
- "Microsoft.FreshPaint"
- "BubbleWitch"
- Any "Autodesk" app
- Any "king" app
- Any "G5" app
- Any "Facebook" app
- Any "Keeper" app
- Any "Plex" app
- Any "Duolingo" app
- Any "EclipseManager" app
- "Acti Pro Software LLC"
- "Adobe Photoshop Express"


Some of the tools you still need to add to Windows Path. This script will do this at some point in the future.

## TODO
- Backup PowerShell profile first
- Add all the installed programs to the PATH
- ~~Remove PSGet requirement if PowerShell version if is better or equal 5~~
