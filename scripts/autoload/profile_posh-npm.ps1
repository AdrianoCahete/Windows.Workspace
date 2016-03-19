# Import posh-npm if isn' in default location
#Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
#$DocumentsFolder = [Environment]::GetFolderPath("MyDocuments")
#Import-Module Join-Path $DocumentsFolder "\WindowsPowerShell\Modules\posh-npm"

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
Import-Module posh-npm

Pop-Location