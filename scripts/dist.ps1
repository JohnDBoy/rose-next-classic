param (
    [ValidateSet("release", "debug")]
    [string]$config = "release",
    [switch]$client = $false,
    [switch]$server = $false,
    [switch]$tools = $false,
    [switch]$database = $false,
    [string]$out = (Join-Path $PSScriptRoot .. "dist/" $config)
)

$rose_next_root = Join-Path $PSScriptRoot ..
$build_root = Join-Path $rose_next_root bin $config
$asset_build_root = Join-Path $rose_next_root bin assets
$doc_root = Join-Path $rose_next_root doc

$client_out = Join-Path $out client/
$server_out = Join-Path $out server/
$tool_out = Join-Path $out tool/
$db_out = Join-Path $out database/

$directxtex_ver = "2020.9.30"
$discord_ver = "2.5.6"

$texconv = Join-Path $rose_next_root thirdparty directxtex-$directxtex_ver texconv.exe
$discord_dll = (Join-Path $rose_next_root thirdparty discord-$discord_ver lib x86 discord_game_sdk.dll)

$squash_script = Join-Path $PSScriptRoot "squash-migrations.ps1"

# If any of the sub projects are manually specified then we can assume the user
# doesn't want "all"
$build_all = $true
if ($client -or $server -or $tools -or $database) {
    $build_all = $false
}

if ($build_all) {
    $client = $server = $tools = $database = $true
}

Write-Host $texconv

Write-Host "Collecting files to $out"

if ($client -eq $true) {
    Write-Host "Collecting client files..."
    if (-not (Test-Path -Path $client_out)) {
        New-Item -ItemType Directory -Force -Path $client_out | Out-Null
    }

    Write-Host "Copying client binaries..."
    xcopy /Y (Join-Path $build_root triggervfs.dll) $client_out
    xcopy /Y (Join-Path $build_root rosenext.exe) $client_out
    xcopy /Y (Join-Path $build_root znzin.dll) $client_out
    xcopy /Y $discord_dll $client_out

    Write-Host "Copying client assets..."
    if ($config -eq "debug") {
        robocopy $asset_build_root $client_out /E /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
        if ($LASTEXITCODE -ge 8) {
            Write-Error "Failed to copy client assets for debug build. Robocopy exit code: $LASTEXITCODE"
            exit 1
        }
    }
    else {
        $pack_script = Join-Path $PSScriptRoot "pack.ps1"
        if (Test-Path -Path $pack_script) {
            Write-Host "Packing client assets for release build..."
            & $pack_script -out $client_out
            if (!$?) {
                Write-Error "Failed to pack client assets using pack.ps1"
                exit 1
            }
        } else {
            Write-Warning "pack.ps1 not found. Asset packing for release build will be skipped."
            Write-Host "As a fallback, copying loose client assets. This is not recommended for a final distribution."
            robocopy $asset_build_root $client_out /E
        }
    }
}
else {
    Write-Host "Skipping client files"
}

if ($server -eq $true) {
    Write-Host "Collecting server binaries"
    xcopy /Y (Join-Path $build_root sho_loginserver.exe) $server_out
    xcopy /Y (Join-Path $build_root sho_worldserver.exe) $server_out
    xcopy /Y (Join-Path $build_root sho_gameserver.exe) $server_out
    xcopy /Y (Join-Path $doc_root server.toml.example) $server_out

    Write-Host "Collecting server assets"
    & ./server-data.ps1 -in $asset_build_root -out $server_out
}
else {
    Write-Host "Skipping server files"
}

if ($tools -eq $true) {
    Write-Host "Collecting tools"
    xcopy /Y (Join-Path $build_root pipeline.exe) $tool_out
    xcopy /Y $texconv $tool_out
}
else {
    Write-Host "Skipping tools"
}

if ($database -eq $true) {
    Write-Host "Squashing database migrations"
    If (!(test-path $db_out)) {
        New-Item -ItemType Directory -Force -Path $db_out
    }

    & $squash_script -out $db_out

    Write-Host "Copying database migration files"
    robocopy (Join-Path $rose_next_root database migrations) (Join-Path $db_out migrations) /E /NP /NJH /NJS /NS
}
else {
    Write-Host "Skipping database"
}