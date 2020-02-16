function Instagram-Downloader {

    # Get from Windows.Workspace Repository [ https://github.com/AdrianoCahete/Windows.Workspace ]
    # Maintaned by Adriano Cahete [ https://github.com/AdrianoCahete/ ]

    [CmdletBinding()]
        param(
		    [Parameter(Position=0,Mandatory=$true)] [string]$UserName,
            [Parameter(Position=1)] [string]$DownloadPath=[Environment]::GetFolderPath("mypictures") 
        )

    if ($UserName -And $DownloadPath) {
        $JsonData = Invoke-WebRequest "http://instagram.com/$UserName/media" | ConvertFrom-Json
        $UserDownloadPath = Join-Path -Path $DownloadPath -ChildPath $UserName

        if(!(Test-Path $UserDownloadPath)){
            New-Item -ItemType Directory -Path $UserDownloadPath
        }
        
        while($JsonData.more_available -eq $true){
            foreach($item in $JsonData.items){
                $ImageURL = $item.images.standard_resolution.url
                $ImageDownloadPath = Join-Path -Path $UserDownloadPath -ChildPath $ImageURL.Split('/')[-1].Split('?')[0]
                Echo "Downloaded to $ImageDownloadPath"

                if(!(Test-Path $ImageDownloadPath)){
                    Invoke-WebRequest $ImageURL -OutFile $ImageDownloadPath
                }
            }

            $LastID = ($JsonData.items | Select -Last 1).id
            $JsonData = Invoke-WebRequest "http://instagram.com/$UserName/media?max_id=$LastID" | ConvertFrom-Json
        }
    } else {
        echo "Insert Username"
        break
    }
}

Instagram-Downloader