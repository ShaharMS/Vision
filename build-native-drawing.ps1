param(
    [Parameter(Mandatory)][string]$HashLink,
    [string]$Wgpu,
    [string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'
$source = (Resolve-Path (Join-Path $PSScriptRoot 'src/vision/formats/__internal')).Path
$hxcpp = (haxelib libpath hxcpp).Trim()
if ($LASTEXITCODE -ne 0) { throw 'Install hxcpp before building the native drawing libraries.' }
$hashLinkRoot = (Resolve-Path -LiteralPath $HashLink).Path
if (-not $OutputDirectory) { $OutputDirectory = Join-Path $PSScriptRoot 'bin/native-drawing' }
$destination = (New-Item -ItemType Directory -Path $OutputDirectory -Force).FullName
$gpuCompiler = @()
$gpuLinker = @()
if ($Wgpu) {
    $wgpuRoot = (Resolve-Path -LiteralPath $Wgpu).Path
    $gpuCompiler = @('/DVISION_WEBGPU', "/I$wgpuRoot/include")
    $gpuLinker = @(Join-Path $wgpuRoot 'lib/wgpu_native.dll.lib')
    Copy-Item -LiteralPath (Join-Path $wgpuRoot 'lib/wgpu_native.dll') -Destination $destination
}

Push-Location -LiteralPath $destination
try {
    & cl.exe /nologo /O2 /std:c11 /c /Fovision_window.obj @gpuCompiler "$source/NativeImageIO.c"
    if ($LASTEXITCODE -ne 0) { throw 'Native drawing compilation failed.' }
    & cl.exe /nologo /O2 /std:c11 /LD "/I$hashLinkRoot/include" "$source/NativeImageIO.hl.c" vision_window.obj @gpuLinker user32.lib gdi32.lib /link /out:vision_native.hdll
    if ($LASTEXITCODE -ne 0) { throw 'HashLink drawing library compilation failed.' }
    & cl.exe /nologo /O2 /LD "/I$hxcpp/include" "$source/NativeImageIO.cpp" vision_window.obj @gpuLinker user32.lib gdi32.lib /link /out:vision_native.ndll
    if ($LASTEXITCODE -ne 0) { throw 'hxcpp drawing library compilation failed.' }
} finally {
    Pop-Location
}
