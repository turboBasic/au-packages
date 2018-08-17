# Import-Module au

$releases = 'https://github.com/bruderstein/nppPluginManager/releases/latest'


function global:au_BeforeUpdate() 
{
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
}


function global:au_GetLatest 
{
    $regex = '_x64.zip$'

    $url64 = Invoke-WebRequest -Uri $releases -UseBasicParsing |
        Select-Object -ExpandProperty links | 
        Where-Object href -match $regex | 
        Select-Object -First 1 -ExpandProperty href

    $version = $url -split '_' | 
        Select-Object -First 1 -Skip 1
    $version = $version -replace 'v', ''

    @{ 
        Version = $version
        URL64 = "https://$url64"
    }
}


function global:au_SearchReplace 
{
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*url64bit\s*=\s*)('.*')"     = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}


update