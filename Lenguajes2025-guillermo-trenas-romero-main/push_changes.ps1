# push_changes.ps1
# Script para añadir, commitear y hacer push de cambios desde la raíz del proyecto.
# Úsalo desde PowerShell en la carpeta del proyecto o ejecuta este archivo directamente.

Set-StrictMode -Version Latest

# Moverse al directorio donde está el script (raíz del repo)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $scriptDir

Write-Host "Directorio actual: $PWD"

# Comprobar git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git no está disponible en el PATH. Instala Git o reinicia la terminal/VS Code y vuelve a intentarlo."
    exit 1
}

git --version

# Comprobar si hay cambios
$changes = git status --porcelain
if (-not $changes) {
    Write-Host "No hay cambios para commitear. Nada que hacer."
    exit 0
}

# Añadir y commitear
git add .
$commitMessage = "Extract styles to css/style.css"

# Intentar commit; si no hay cambios que commitear, continuar
try {
    git commit -m $commitMessage
} catch {
    Write-Warning "git commit devolvió un error (puede que no hubiera cambios nuevos). Continuando con push si procede."
}

# Hacer push
try {
    git push
} catch {
    Write-Error "git push falló. Comprueba la configuración del remoto y credenciales."
    exit 1
}

Write-Host "Push completado (o no había cambios)." -ForegroundColor Green
