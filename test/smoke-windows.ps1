# Smoke test of the Windows image: install LeviLamina and the packages of test/packages.txt into a
# new volume, start the server, check that every package is installed and every mod is loaded, that
# the server answers on UDP 19132, that `docker stop` stops it cleanly, and that a second start
# reuses the installation.
#
# Usage: test/smoke-windows.ps1 <image>

param([Parameter(Mandatory)][string]$Image)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$Name = "levilamina-smoke-$PID"
$Packages = Get-Content (Join-Path $PSScriptRoot 'packages.txt') | Where-Object { $_ -notmatch '^\s*(#|$)' }
$InstallTimeout = 2400
$StartTimeout = 600

function Fail([string]$Message) {
  Write-Output "::error::$Message"
  throw $Message
}

function Get-Log { (docker logs $Name 2>&1 | Out-String) -replace "`e\[[0-9;]*m", '' }

function Wait-ForLog([int]$Count, [string]$Pattern, [int]$Timeout) {
  $watch = [Diagnostics.Stopwatch]::StartNew()
  while (([regex]::Matches((Get-Log), $Pattern)).Count -lt $Count) {
    if ((docker inspect -f '{{.State.Running}}' $Name) -ne 'true') {
      Fail "The container stopped before its log showed /$Pattern/ (exit code $(docker inspect -f '{{.State.ExitCode}}' $Name))."
    }
    if ($watch.Elapsed.TotalSeconds -ge $Timeout) {
      Fail "The log did not show /$Pattern/ within $Timeout s."
    }
    Start-Sleep 5
  }
}

function Test-Mods {
  $log = Get-Log
  $mods = @(docker exec $Name powershell -NoProfile -Command "Get-ChildItem C:\data\mods -Directory | ForEach-Object Name")
  Write-Output "Mods: $($mods -join ' ')"
  if ($mods.Count -le 1) { Fail 'No mod is installed.' }
  $bad = $false
  foreach ($mod in $mods) {
    # LeviLamina is the loader; it loads every other mod.
    if ($mod -eq 'LeviLamina') { continue }
    if (-not $log.Contains("[LeviLamina] $mod loaded")) {
      Write-Output "::error::LeviLamina did not load $mod."
      $bad = $true
    }
    if (-not $log.Contains("[LeviLamina] Enabling $mod v")) {
      Write-Output "::error::LeviLamina did not enable $mod."
      $bad = $true
    }
  }
  # Log levels: LeviLamina writes ERR and FTL, PreLoader ERROR and FATAL.
  $errors = $log -split "`n" | Where-Object { $_ -cmatch '^[0-9:.]+ +(ERR|FTL|ERROR|FATAL) ' }
  if ($errors) {
    $errors | Write-Output
    Write-Output '::error::The log reports errors.'
    $bad = $true
  }
  if ($bad) { Fail 'Some mods are not loaded.' }
}

# The server answers a RakNet unconnected ping on UDP 19132 inside the container.
function Test-Ping {
  $script = @'
$magic = [byte[]](0x00,0xff,0xff,0x00,0xfe,0xfe,0xfe,0xfe,0xfd,0xfd,0xfd,0xfd,0x12,0x34,0x56,0x78)
$udp = New-Object Net.Sockets.UdpClient
$udp.Client.ReceiveTimeout = 2000
$end = [DateTime]::UtcNow.AddSeconds(60)
while ([DateTime]::UtcNow -lt $end) {
  $ping = [byte[]](@(0x01) + [BitConverter]::GetBytes([long]0) + $magic + [byte[]](1..8))
  [void]$udp.Send($ping, $ping.Length, '127.0.0.1', 19132)
  try {
    $ep = New-Object Net.IPEndPoint ([Net.IPAddress]::Any, 0)
    $data = $udp.Receive([ref]$ep)
  } catch { continue }
  if ($data.Length -gt 35 -and $data[0] -eq 0x1c) {
    $length = $data[33] * 256 + $data[34]
    $motd = [Text.Encoding]::UTF8.GetString($data, 35, $length)
    Write-Output $motd
    if ($motd.StartsWith('MCPE;')) { exit 0 } else { exit 1 }
  }
}
exit 1
'@
  $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($script))
  docker exec $Name powershell -NoProfile -EncodedCommand $encoded
}

function Stop-Server([int]$Times) {
  docker stop -t 120 $Name | Out-Null
  $code = docker inspect -f '{{.State.ExitCode}}' $Name
  if ($code -ne '0') { Fail "The container exited with code $code after docker stop." }
  if (([regex]::Matches((Get-Log), 'Quit correctly')).Count -lt $Times) {
    Fail 'The server did not quit correctly after docker stop.'
  }
}

$ok = $false
try {
  Write-Output '::group::First start: install and run'
  docker volume create $Name | Out-Null
  docker run -d --isolation=hyperv --name $Name -e EULA=TRUE -e "PACKAGES=$($Packages -join ' ')" -v "${Name}:C:\data" $Image | Out-Null
  Wait-ForLog 1 'Server started in' $InstallTimeout
  Write-Output '::endgroup::'

  Write-Output '::group::Installed packages'
  $list = docker exec $Name lip.exe list --json | Out-String
  Write-Output $list
  $installed = (ConvertFrom-Json $list).ExplicitInstalled
  foreach ($package in @('github.com/LiteLDev/LeviLamina') + $Packages) {
    if (-not ($installed | Where-Object { $_.StartsWith("$package@", [StringComparison]::OrdinalIgnoreCase) })) {
      Fail "$package is not explicitly installed."
    }
  }
  Write-Output '::endgroup::'

  Write-Output '::group::Links in the volume (diagnostic)'
  docker exec $Name cmd /c "whoami & mklink /J C:\data\probe-junction C:\data\mods & mklink /D C:\data\probe-symlink C:\data\mods & mklink /J C:\probe-junction C:\data\mods & dir C:\data" 2>&1 | Write-Output
  Write-Output '::endgroup::'

  Write-Output '::group::Loaded mods'
  Test-Mods
  Write-Output '::endgroup::'

  Write-Output '::group::Network'
  Test-Ping
  Write-Output '::endgroup::'

  Write-Output '::group::Stop'
  Stop-Server 1
  Write-Output '::endgroup::'

  Write-Output '::group::Second start: reuse the installation'
  docker start $Name | Out-Null
  Wait-ForLog 2 'Server started in' $StartTimeout
  Test-Mods
  Test-Ping
  Stop-Server 2
  Write-Output '::endgroup::'
  $ok = $true
}
finally {
  Write-Output '::group::Container log'
  Get-Log | Write-Output
  Write-Output '::endgroup::'
  docker rm -f $Name 2>&1 | Out-Null
  docker volume rm -f $Name 2>&1 | Out-Null
}
if (-not $ok) { exit 1 }
