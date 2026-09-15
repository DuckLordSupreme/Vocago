param(
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version = '1.0.1',
    [string]$OutputDirectory = 'dist',
    [string]$WixDirectory = '',
    [switch]$SkipBuild,
    [switch]$SkipInstaller
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
Push-Location $projectRoot
$originalPath = $env:PATH
try {
    if ($env:OS -ne 'Windows_NT') { throw 'Run this script on Windows with JDK 21.' }
    $jpackage = (Get-Command jpackage.exe -ErrorAction Stop).Source
    if ($WixDirectory) {
        $env:PATH = (Resolve-Path $WixDirectory).Path + ';' + $env:PATH
    } elseif (Test-Path 'build/tools/wix314/candle.exe') {
        $env:PATH = (Resolve-Path 'build/tools/wix314').Path + ';' + $env:PATH
    }
    if (-not $SkipInstaller) {
        Get-Command candle.exe, light.exe -ErrorAction Stop | Out-Null
    }
    $destination = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputDirectory))
    $appImage = Join-Path $destination 'Vocago'
    if (Test-Path $appImage) {
        throw "Output already exists: $appImage. Choose a fresh -OutputDirectory."
    }
    if (-not $SkipBuild) {
        & .\gradlew.bat build
        if ($LASTEXITCODE -ne 0) { throw 'Gradle build failed.' }
    }
    $jars = @(Get-ChildItem 'build/libs/*-all.jar')
    if ($jars.Count -ne 1) { throw 'Expected exactly one build/libs/*-all.jar.' }
    # An isolated input ensures jpackage includes only the application JAR.
    $staging = Join-Path $projectRoot ('build/windows-input/' + [guid]::NewGuid())
    New-Item -ItemType Directory -Path $staging -Force | Out-Null
    Copy-Item -LiteralPath $jars[0].FullName -Destination (Join-Path $staging 'OOP25-Vocago-all.jar')
    & $jpackage --type app-image --name Vocago --app-version $Version `
        --input $staging --main-jar OOP25-Vocago-all.jar --dest $destination `
        --java-options '-Dvocago.packaged=true' --vendor 'Vocago' `
        --description 'Vocabulary learning desktop application' `
        --icon 'src/main/resources/pictures/wizard.ico'
    if ($LASTEXITCODE -ne 0) { throw 'Application image packaging failed.' }
    $zip = Join-Path $destination "Vocago-$Version-windows-x64.zip"
    Compress-Archive -LiteralPath $appImage -DestinationPath $zip
    if (-not $SkipInstaller) {
        & $jpackage --type exe --name Vocago --app-version $Version `
            --app-image $appImage --dest $destination --vendor 'Vocago' `
            --icon 'src/main/resources/pictures/wizard.ico' `
            --win-per-user-install --win-menu --win-shortcut --win-dir-chooser `
            --win-upgrade-uuid '4655fabe-9ed9-4ec1-a8ab-3ab17c274d89'
        if ($LASTEXITCODE -ne 0) { throw 'Installer packaging failed.' }
    }
    Get-ChildItem -LiteralPath $destination
} finally {
    $env:PATH = $originalPath
    Pop-Location
}
