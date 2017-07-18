Import-Module au



$releases = 'http://www.pspad.com/en/download.php'



function global:au_SearchReplace {

   @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*url32\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum32\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }

}



function global:au_GetLatest {

    $download_page = Invoke-WebRequest -Uri $releases


    $header = $download_page.ParsedHtml.getElementsByTagName('h2') | 
        Where { $_.InnerHTML -match 'PSPad\s+-\s+current\s+version\s+(\d+\.\d+\.\d+)\s+\((\d+)\)' }
        
    $version = $Matches[1]
    $build   = $Matches[2]   
    $versionShort = $version -replace '.',''
    
    $regexInstall = "\/files\/pspad($VersionShort)en\.zip$"
    
    $urlInstall =  $download_page.links | 
        Where href -match $regexInstall | 
        Select -First 1 -ExpandProperty href
    
    $url64 = $url32 = $urlInstall
    $fileName = Split-path $urlInstall -Leaf
    
    
    $download_page.AllElements | 
        Where { 
            ( $_.tagName -eq 'CODE' ) -and 
            ( $_.innerText -match "([0-9A-F]{32})\s+(\S+.exe)\s+([0-9A-F]{32})\s+($fileName)" ) 
        } | 
        Select -ExpandProperty innerText 

        
    @{
        URL32              = $url32
        URL64              = $null
        FileName           = $fileName
        Versionshort       = $versionShort
        Version            = $version
        Build              = $build
        Checksum32exe      = $Matches[1]
        FileNameExe        = $Matches[2]
        Checksum32         = $Matches[3]
        ChecksumType32     = 'md5'
    }

}



Update
