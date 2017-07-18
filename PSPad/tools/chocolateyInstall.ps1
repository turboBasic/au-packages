# you do not edit below this line! in fact you DO NOT edit below the line above this one.

$ErrorActionPreference = 'Stop'



$packageArgs = @{
  packageName    = 'PSPad'
  fileType       = 'exe'
  file           = Get-Item $toolsDir\*.zip
  checksumType32 = 'md5';
  unzipLocation  = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
  skipShims      = @('phpCB.exe', 'TiDy.exe')
  silentArgs     = '/VERYSILENT'
  validExitCodes = @(0)
  softwareName   = 'PSPad*'
}



Install-ChocolateyPackage @packageArgs
rm $toolsDir\pspad*setup.exe -ea 0

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation "$packageName*"
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"
