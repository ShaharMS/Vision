[CmdletBinding()]
param([string]$OutputDirectory = '')

$ErrorActionPreference = 'Stop'
if (-not $OutputDirectory) { $OutputDirectory = Join-Path $PSScriptRoot 'release' }
$manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'haxelib.json') -Raw | ConvertFrom-Json
$version = $manifest.version
if ($version -notmatch '^\d+\.\d+\.\d+(?:[-+][A-Za-z0-9.-]+)?$') { throw 'Invalid package version.' }
$taskStamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$packageRoot = Join-Path $OutputDirectory "vision-$version-$taskStamp"
New-Item -ItemType Directory -Path $packageRoot -ErrorAction Stop | Out-Null
foreach ($name in @('extraParams.hxml', 'CHANGELOG.md', 'LICENSE', 'README.md', 'haxelib.json', 'hxformat.json', 'src')) {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination $packageRoot -Recurse -ErrorAction Stop
}
$archive = "$packageRoot.zip"
Compress-Archive -Path (Join-Path $packageRoot '*') -DestinationPath $archive -ErrorAction Stop
Write-Output $archive
