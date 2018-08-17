# you do not edit below this line! in fact you DO NOT edit below the line above this one.

$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$NotepadPlusPlusApplicationPath = "${ENV:ProgramFiles}/Notepad++"
$NotepadPlusPlusProcessName = 'Notepad++'
$assetsToCopy = 'updater', 'plugins'
$ignoreShims = 'updater/gpup.exe'



$packageArgs = @{
  PackageName            = 'notepadplusplus-nppPluginManager'
  UnzipLocation          = $toolsPath
  Url64bit               = 'https://github.com/bruderstein/nppPluginManager/releases/download/v1.4.11/PluginManager_v1.4.11_x64.zip'
  Checksum64             = '7336C78153D8CF5CC6775E588780EA40A7DB0BD176D317AD623422FDA228D553'
  ChecksumType64         = 'sha256'
  SoftwareName           = 'nppPluginManager*'
}
Install-ChocolateyZipPackage @packageArgs



# Generate .ignore files to avoid creating shims
foreach ($file in $ignoreShims) {
    New-Item -Path (Join-Path -Path $toolsPath -ChildPath "${file}.ignore") -ItemType File -Force -Verbose:$VerbosePreference | 
        Out-Null
}



if ( Test-Path -Path $NotepadPlusPlusApplicationPath ) 
{
    Get-Process -Name $NotepadPlusPlusProcessName -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Warning "Closing running instances of Notepad++, please save your files"
        $_.CloseMainWindow() | Out-Null 
    }
    Start-Sleep -Milliseconds 500
    if ($VerbosePreference) {
        Get-Process -Name $NotepadPlusPlusProcessName -ErrorAction SilentlyContinue 
    }
    Copy-Item -Path $toolsPath/* -Include $assetsToCopy -Destination $NotepadPlusPlusApplicationPath -Force -Recurse -Confirm:$False -Verbose:$VerbosePreference
}
