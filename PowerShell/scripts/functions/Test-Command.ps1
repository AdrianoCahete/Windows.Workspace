Function Test-Command {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'

    try {
        if(Get-Command $command){
            RETURN $true
        }
    } Catch {
        RETURN $false
    } Finally {
        $ErrorActionPreference = $oldPreference
    }
}