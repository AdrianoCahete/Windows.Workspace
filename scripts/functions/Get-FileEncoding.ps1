# Get-FileEncoding

# Get from Windows.Workspace Repository [ https://github.com/AdrianoCahete/Windows.Workspace ]
# Maintaned by Adriano Cahete [ https://github.com/AdrianoCahete/ ]
function Get-FileEncoding($Path) {
    $bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if(!$bytes) { return "utf8" }

    switch -regex ("{0:x2}{1:x2}{2:x2}{3:x2}" -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
        "^efbbbf"   { return "utf8" }
        "^2b2f76"   { return "utf7" }
        "^fffe"     { return "unicode" }
        "^feff"     { return "bigendianunicode" }
        "^0000feff" { return "utf32" }
        default     { return "ascii" }
    }
}