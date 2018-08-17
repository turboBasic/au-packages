# you do not edit below this line! in fact you DO NOT edit below the line above this one.

$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  PackageName            = 'notepadplusplus-nppPluginManager'
  UnzipLocation          = $toolsPath
  Url64bit               = 'https://github.com/bruderstein/nppPluginManager/releases/download/v1.4.11/PluginManager_v1.4.11_x64.zip'
  Checksum64             = '7336C78153D8CF5CC6775E588780EA40A7DB0BD176D317AD623422FDA228D553'
  ChecksumType64         = 'sha256'
  SoftwareName           = 'nppPluginManager*'
}
Install-ChocolateyZipPackage @packageArgs

if ( Test-Path -Path ${ENV:ProgramFiles}/Notepad++ ) 
{
    Copy-Item -Path $toolsPath/updater/gpup.exe -Destination ${ENV:ProgramFiles}/Notepad++/updater -Force
    Copy-Item -Path $toolsPath/plugins/PluginManager.dll -Destination ${ENV:ProgramFiles}/Notepad++/plugins -Force
}
