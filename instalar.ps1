# Instalador de PriShot para Windows (x64).
# Uso (PowerShell):  irm https://raw.githubusercontent.com/jose-albarracin/prishot-descargas/main/instalar.ps1 | iex
#
# Descarga el instalador de la última versión publicada, comprueba su sha256,
# lo instala en silencio para el usuario actual (sin pedir administrador),
# con inicio en Windows, y abre PriShot.
# Todo va dentro de & { } para no dejar variables ni preferencias en la sesión de quien lo pega.
& {
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'   # Invoke-WebRequest es mucho más lento con la barra

$Repo    = 'jose-albarracin/prishot-descargas'
$Base    = "https://github.com/$Repo/releases/latest/download"
$ExeName = 'PriShot-Setup-x64.exe'

if (-not [Environment]::Is64BitOperatingSystem) { throw 'PriShot necesita Windows de 64 bits.' }

$tmp = Join-Path ([IO.Path]::GetTempPath()) ("prishot-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path $tmp | Out-Null
try {
    Write-Host '==> Descargando PriShot...'
    $setup = Join-Path $tmp $ExeName
    Invoke-WebRequest -UseBasicParsing -Uri "$Base/$ExeName" -OutFile $setup
    $sums = (Invoke-WebRequest -UseBasicParsing -Uri "$Base/SHA256SUMS.txt").Content
    if ($sums -is [byte[]]) { $sums = [Text.Encoding]::UTF8.GetString($sums) }

    Write-Host '==> Comprobando el archivo...'
    $line = ($sums -split "`n") | Where-Object { $_ -match " $([regex]::Escape($ExeName))\s*$" } | Select-Object -First 1
    if (-not $line) { throw "SHA256SUMS.txt no trae $ExeName." }
    $expected = ($line -split '\s+')[0].ToLower()
    $actual = (Get-FileHash -Algorithm SHA256 $setup).Hash.ToLower()
    if ($expected -ne $actual) { throw 'El sha256 no coincide; descarga dañada. Vuelve a intentarlo.' }

    # Por si acaso: si algo marcó el archivo como descargado de internet, se quita la marca.
    Unblock-File $setup

    Write-Host '==> Instalando...'
    $p = Start-Process -FilePath $setup -Wait -PassThru -ArgumentList @(
        '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/CLOSEAPPLICATIONS', '/CURRENTUSER', '/TASKS=autostart')
    if ($p.ExitCode -ne 0) { throw "El instalador terminó con código $($p.ExitCode)." }

    $exe = Join-Path $env:LOCALAPPDATA 'Programs\PriShot\PriShot.exe'
    if (-not (Test-Path $exe)) { throw "No encuentro $exe después de instalar." }
    Write-Host "==> PriShot quedó en $exe"
    Start-Process -FilePath $exe
    Write-Host ''
    Write-Host 'Listo. PriShot vive en la bandeja del sistema (junto al reloj).'
    Write-Host '  ImpPt            capturar una región'
    Write-Host '  Mayús+ImpPt      guardar la pantalla'
    Write-Host '  Ctrl+ImpPt       copiar la pantalla'
    Write-Host 'Para actualizar, vuelve a pegar el mismo comando.'
}
finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
}
