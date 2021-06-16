# Ensure that Get-ChildItemColor is loaded
Import-Module Get-ChildItemColor

# Ensure posh-git is loaded
Import-Module -Name posh-git

# Ensure z is loaded
Import-Module z

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColor -Option AllScope

# Git alises
# https://github.com/github/hub#powershell
Set-Alias git hub

Set-Alias gut git -Option AllScope
Set-Alias gti git -Option AllScope
Set-Alias got git -Option AllScope
Set-Alias giot git -Option AllScope
Set-Alias goit git -Option AllScope
Set-Alias gitr git -Option AllScope

Set-Alias gpl -Value Git-Pull -Option AllScope

# Powershell
Set-Alias list-modules -Value Get-InstalledModule -Option AllScope
Set-Alias update-modules -Value Get-InstalledModule | Update-Module

# .NET
Set-Alias gotnet dotnet -Option AllScope
Set-Alias dot dotnet -Option AllScope
Set-Alias dn dotnet -Option AllScope

# Meteor
Set-Alias met -Value Meteor-Helper -Option AllScope
Set-Alias myarn -Value Meteor-Helper -Option AllScope

Set-Alias pf -Value Port-Finder -Option AllScope

# NPM
Set-Alias nb -Value NPM-Helper -Option AllScope
Set-Alias fbuild -Value NPM-Helper -Option AllScope

# Remove NodeModules
Set-Alias npmclear -Value Clear-Node-Modules
Set-Alias rmnm -Value Clear-Node-Modules 
Set-Alias rmn -Value Clear-Node-Modules
Set-Alias rnm -Value Clear-Node-Modules
Set-Alias npm-clear -Value Clear-Node-Modules
Set-Alias npmcls -Value Clear-Node-Modules
Set-Alias clean-nm -Value Clear-Node-Modules


# VSCode
Set-Alias vscode code -Option AllScope


# YTDL
Set-Alias ytdl youtube-dl -Option AllScope
Set-Alias yt youtube-dl -Option AllScope


# https://github.com/blackjack4494/yt-dlc
Set-Alias ytdlc youtube-dlc -Option AllScope
Set-Alias ytd youtube-dlc -Option AllScope
Set-Alias ytc youtube-dlc -Option AllScope
Set-Alias yt2 youtube-dlc -Option AllScope
Set-Alias ytdl2 youtube-dlc -Option AllScope

# Python
Set-Alias pyupdate Python-Update-All -Option AllScope
Set-Alias py-update Python-Update-All -Option AllScope
Set-Alias pipupdate Python-Update-All -Option AllScope
Set-Alias pip-update Python-Update-All -Option AllScope
Set-Alias pip-upgrade Python-Update-All -Option AllScope

# WhereIs
Set-Alias whereis which -Option AllScope

# Pret Finder
Set-Alias PortFinder Port-Finder -Option AllScope

# SysInfo
Set-Alias sysinfo Screenfetch -Option AllScope

# HashGen
Set-Alias hash HashFile -Option AllScope
Set-Alias sha HashFile -Option AllScope

# SignText
Set-Alias st SignText -Option AllScope
Set-Alias sign SignText -Option AllScope

# Archive Now
Set-Alias an archivenow -Option AllScope
Set-Alias archive archivenow -Option AllScope


# Helper function to show Unicode characters
function U {
    param
    (
        [int] $Code
    )
 
    if ((0 -le $Code) -and ($Code -le 0xFFFF))
    {
        return [char] $Code
    }
 
    if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF))
    {
        return [char]::ConvertFromUtf32($Code)
    }
 
    throw "Invalid character code $Code"
}

# Clear Node-Modules
function Clear-Node-Modules {
	if (Test-Path ./node_modules -PathType Container) {
		echo "Clearing node_modules folder..."
		Try {
			Remove-Item -Recurse -Force ./node_modules
			echo "[!] node_modules folder has been removed."
		} Catch {
			echo "node_modules folder cannot been removed."
		}
		
	} else {
		echo "node_modules folder doesn't exist, you can run 'npm install' now"
	}
}

# Create Hash File
function HashFile {
   [CmdletBinding()]        
	Param (
    [parameter(Mandatory=$true)]
    [String]$Path,
   
    [parameter(Mandatory=$false)]
    [String]$Algo = 'SHA512'
   )
   
   $filename = $Path + '.' + $Algo.ToLower()
   
   (Get-FileHash -Path $Path -Algorithm $Algo).Hash
   
   write-output "`nThe file $filename has been created"
   (Get-FileHash -Path $Path -Algorithm $Algo).Hash > $filename
}

# Create Hash File
function SignText {
   [CmdletBinding()]        
	Param (
    [parameter(Mandatory=$true)]
    [String]$Text,
   
    [parameter(Mandatory=$false)]
    [String]$Email = '',
	
	[parameter(Mandatory=$false)]
    [String]$Algo = 'SHA512'
   )
   
	Write-Output "`n'$Text' will be signed using '$email' `n"
	Write-Output $Text | gpg --clear-sign --armor -u $Email --digest-algo $Algo
}


# Create and navigate to folder
function mk {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      $Path
   )

   New-Item -Path $Path -ItemType Directory
   Set-Location -Path $Path
}


# Git Pull Helper
function Git-Pull
{
    param
    ($p1 = '')

    git pull "$p1"

}

# NPM Helper -- To Be used with Aliases
function NPM-Helper
{
    param
    ($p1 = 'run')
	($p2 = 'build-local')

    npm "$p1" "$p2"

}

# Meteor Helper -- To Be used with Aliases
function Meteor-Helper
{
    param
    ($p1 = 'yarn')
	($p2 = 'start')

    meteor npx "$p1" "$p2"

}

# Python Helper
function Python-Update-All
{
	echo "`nUpdating all Python packages...`n"
	pip freeze | %{$_.split('==')[0]} | %{pip install --upgrade $_}
}

# Which/Where
function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

# Port Finder
function Port-Finder
{
	param
	($port = '')
	($kill = '')
	
	if ($port) {
		try {
			Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess
			
			if ($kill) {
				try {
					taskkill /pid (Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess).Id /f
				}
				catch {
					echo "Isn't possible to kill this proccess"
				}
				
			}
		} catch {
			echo "There's nothing running on this port"
		}
	} else {
		echo 'Specify the port number'
	}
}


# PoshGit config
# https://github.com/dahlbyk/posh-git
$GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::Red
$GitPromptSettings.DefaultPromptWriteStatusFirst = $false # Path [branch name]
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n' # Breakline
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true # Change c:\User to ~

function prompt {
    $origLastExitCode = $LASTEXITCODE

    $prompt = ""

    $prompt += Write-Prompt "`n$($ExecutionContext.SessionState.Path.CurrentLocation)" -ForegroundColor White
    $prompt += Write-VcsStatus
    $prompt += Write-Prompt "$(if ($PsDebugContext) {' [DBG]: '} else {''})" -ForegroundColor Magenta
    $prompt += "`n$('λ' * ($nestedPromptLevel + 1)) "

    $LASTEXITCODE = $origLastExitCode
    $prompt
}
