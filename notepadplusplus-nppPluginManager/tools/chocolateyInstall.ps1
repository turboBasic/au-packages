# you do not edit below this line! in fact you DO NOT edit below the line above this one.

$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# @TODO: query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Notepad++ to find installation path 
# @TODO: ? decide if portable version (Notepad++.portable) should be supported

$registryInstallationPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Notepad++"
$portableInstallationPath = "${env:AllUsersProfile}\chocolatey\lib\notepadplusplus.commandline\tools"
if (Test-Path $registryInstallationPath)
{
    $NotepadPlusPlusApplicationPath = Split-Path -Parent -Path (
        Get-ItemProperty -Path $registryInstallationPath
    ).DisplayIcon
}
elseif (Test-Path $portableInstallationPath)
{
    $NotepadPlusPlusApplicationPath = $portableInstallationPath
}

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
else {
    throw "Cannot find installation of Notepad++ 64-bit. Only 64-bit build is supported"
}
