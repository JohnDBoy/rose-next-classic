param (
    # The build configuration
    [ValidateSet("release", "debug")]
    [string]$config = "release",

    # Directroy to assets
    [Parameter(Mandatory = $true)]
    [ValidateScript( { Test-Path $_ })]
    [string]$assets_dir,

    # Directory for asset build dir
    [Parameter(Mandatory = $true)]
    [string]$build_dir = (Join-Path $PSScriptRoot .. "build/client"),

    [switch]$noclient = $false,
    [switch]$nopack = $false,
    [string]$client_out = (Join-Path $PSScriptRoot .. "dist/client"),
    [switch]$noserver = $false,
    [string]$server_out = (Join-Path $PSScriptRoot .. "dist/server/data")
)

$rose_next_root = (Get-Item $PSScriptRoot).Parent
$pipeline = (Join-Path $rose_next_root "bin" $config "pipeline.exe")

if ($noclient -eq $false) {
    if (-not (Test-Path -Path $pipeline)) {
        Write-Error "pipeline.exe not found at '$pipeline'. Please build the project first."
        exit 1
    }

    # Bake assets from source to an intermediate build directory
    $bake_manifest = (Join-Path $assets_dir "bake.manifest")
    if (-not (Test-Path -Path $bake_manifest)) {
        Write-Error "Bake manifest not found at '$bake_manifest'."
        exit 1
    }
    Write-Host "Baking client assets from '$assets_dir' to '$build_dir'..."
    & $pipeline bake -c $bake_manifest $assets_dir $build_dir
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Asset baking failed with exit code $LASTEXITCODE."
        exit 1
    }

    # Ensure the final client output directory exists
    if (-not (Test-Path -Path $client_out)) {
        New-Item -ItemType Directory -Force -Path $client_out | Out-Null
    }

    # Pack assets if not disabled, otherwise copy the baked assets
    if ($nopack -eq $false) {
        $pack_manifest = (Join-Path $assets_dir "pack.manifest")
        if (-not (Test-Path -Path $pack_manifest)) {
            Write-Error "Pack manifest not found at '$pack_manifest'."
            exit 1
        }
        Write-Host "Packing client assets from '$build_dir' to '$client_out'..."
        & $pipeline pack -c $pack_manifest $build_dir $client_out
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Asset packing failed with exit code $LASTEXITCODE."
            exit 1
        }
    }
    else {
        Write-Host "Packing skipped. Copying baked assets from '$build_dir' to '$client_out'..."
        robocopy $build_dir $client_out /E /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
        if ($LASTEXITCODE -ge 8) {
            Write-Error "Failed to copy baked assets. Robocopy exit code: $LASTEXITCODE."
            exit 1
        }
    }
}

if ($noserver -eq $false) {
    # xcopy is sensitive to slashes
    $build_dir = $build_dir -replace '/', '\'
    $server_out = $server_out -replace '/', '\'
    Write-Host "Copy asset files for server to $server_out"

    xcopy "$build_dir\3ddata\npc\*.chr" "$server_out\3ddata\npc\" /S /Y /D
    xcopy "$build_dir\3ddata\npc\*.zsc" "$server_out\3ddata\npc\" /S /Y /D
    xcopy "$build_dir\3ddata\npc\*.zmo" "$server_out\3ddata\npc\" /S /Y /D
    xcopy "$build_dir\3ddata\mdata\*.zmo" "$server_out\3ddata\mdata\" /S /Y /D
    xcopy "$build_dir\3ddata\pat\*.zmo" "$server_out\3ddata\pat\" /S /Y /D
    xcopy "$build_dir\3ddata\questdata\*.qsd" "$server_out\3ddata\questdata\" /S /Y /D
    xcopy "$build_dir\3ddata\questdata\*.stb" "$server_out\3ddata\questdata\" /S /Y /D
    xcopy "$build_dir\3ddata\motion\*.zmo" "$server_out\3ddata\motion\" /S /Y /D
    xcopy "$build_dir\3ddata\maps\*.him" "$server_out\3ddata\maps\" /S /Y /D
    xcopy "$build_dir\3ddata\maps\*.mov" "$server_out\3ddata\maps\" /S /Y /D
    xcopy "$build_dir\3ddata\maps\*.ifo" "$server_out\3ddata\maps\" /S /Y /D
    xcopy "$build_dir\3ddata\maps\*.zon" "$server_out\3ddata\maps\" /S /Y /D
    xcopy "$build_dir\3ddata\effect\*.zmo" "$server_out\3ddata\effect\" /S /Y /D
    xcopy "$build_dir\3ddata\ai\*.aip" "$server_out\3ddata\ai\" /S /Y /D
    xcopy "$build_dir\3ddata\ai\*.stb" "$server_out\3ddata\ai\" /S /Y /D
    xcopy "$build_dir\3ddata\stb\*.stb" "$server_out\3ddata\stb\" /S /Y /D
    xcopy "$build_dir\3ddata\stb\*.stl" "$server_out\language\" /S /Y /D
    xcopy "$build_dir\3ddata\stb\list_quest_s.stl" "$server_out\3ddata\questdata\" /S /Y /D
}