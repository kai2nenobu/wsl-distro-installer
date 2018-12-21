Param(
  [ValidateSet('Ubuntu-18.04', 'Debian', 'Kali', 'OpenSUSE')][string]$Distro
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$InstallLocation = Join-Path ${env:LOCALAPPDATA} 'WSL'
$Distros = @{
  'Ubuntu-18.04' = @{
    'Name' = 'Ubuntu-18.04'
    'PackageUrl' = 'https://aka.ms/wsl-ubuntu-1804'
    'Exe' = 'ubuntu1804.exe'
  };
  'Debian' = @{
    'Name' = 'Debian'
    'PackageUrl' = 'https://aka.ms/wsl-debian-gnulinux'
    'Exe' = 'debian.exe'
  };
  'Kali' = @{  # DO NOT WORK!
    'Name' = 'Kali'
    'PackageUrl' = 'https://aka.ms/wsl-kali-linux'
    'Exe' = 'kali.exe'
  };
  'OpenSUSE' = @{  # DO NOT WORK!
    'Name' = 'openSUSE-42'
    'PackageUrl' = 'https://aka.ms/wsl-opensuse-42'
    'Exe' = 'openSUSE-42.exe'
  };
}

$distroArchive = $Distros[$Distro]['Name'] + '.zip'
$distroUrl = $Distros[$Distro]['PackageUrl']
#$distroPath = Join-Path $InstallLocation $distroName
$distroPath = Join-Path '.' $Distros[$Distro]['Name']
$distroExe = Join-Path $distroPath $Distros[$Distro]['Exe']

## Download a distro package
Invoke-WebRequest -Uri $distroUrl -OutFile $distroArchive -UseBasicParsing

## Extract
Expand-Archive -Path $distroArchive -DestinationPath $distroPath -Force
# TODO Abort when the distro is already installed

## Install
Start-Process -FilePath $distroExe -ArgumentList install,--root -NoNewWindow -Wait

## TODO Add a distro exe to PATH
## TODO Set default distro if required
