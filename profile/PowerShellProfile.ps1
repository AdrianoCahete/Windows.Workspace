# Powershell Profile created by Adriano Cahete [ https://github.com/AdrianoCahete/Windows.Workspace ]
# Profile Sample Last Update in 2020-03

# Ensure that Get-ChildItemColor is loaded
Import-Module Get-ChildItemColor

# Ensure posh-git is loaded
Import-Module -Name posh-git

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColor -Option AllScope

# Git alises
Set-Alias gut git -Option AllScope
Set-Alias gti git -Option AllScope
Set-Alias giot git -Option AllScope
Set-Alias goit git -Option AllScope

Set-Alias gpl -Value Git-Pull -Option AllScope

# dotnet alisas
Set-Alias gotnet dotnet -Option AllScope
Set-Alias dot dotnet -Option AllScope
Set-Alias dn dotnet -Option AllScope

# npm aliasas
Set-Alias nb -Value NPM-Helper -Option AllScope
Set-Alias fbuild -Value NPM-Helper -Option AllScope

# # Helper function to show Unicode characters
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

# PoshGit config
# https://github.com/dahlbyk/posh-git
$GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::Red
$GitPromptSettings.DefaultPromptWriteStatusFirst = $false # Path [branch name]
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n' # Breakline
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true # Change c:\User to ~

function prompt {
    $origLastExitCode = $LASTEXITCODE

    $prompt = ""

    $prompt += Write-Prompt "$($ExecutionContext.SessionState.Path.CurrentLocation)" -ForegroundColor White
    $prompt += Write-VcsStatus
    $prompt += Write-Prompt "$(if ($PsDebugContext) {' [DBG]: '} else {''})" -ForegroundColor Magenta
    $prompt += "`n$('λ' * ($nestedPromptLevel + 1)) "

    $LASTEXITCODE = $origLastExitCode
    $prompt
}
