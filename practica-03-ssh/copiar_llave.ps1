# Práctica 3 — Genera tu llave SSH (si no existe) y la copia a los 4 nodos del grupo (Windows).
# Uso:  powershell -ExecutionPolicy Bypass -File copiar_llave.ps1 -Grupo a
param(
    [Parameter(Mandatory)][ValidateSet('a', 'b')][string]$Grupo
)

$base = if ($Grupo -eq 'a') { 10 } else { 20 }
$nodos = 0..3 | ForEach-Object { "192.168.20.$($base + $_)" }
$llave = "$env:USERPROFILE\.ssh\id_ed25519.pub"

if (-not (Test-Path $llave)) {
    Write-Host "Generando llave ed25519 (acepta las opciones con Enter)..."
    ssh-keygen -t ed25519
}

foreach ($ip in $nodos) {
    Write-Host "`n--- $ip --- (escribe la contraseña del usuario cluster)"
    Get-Content $llave | ssh "cluster@$ip" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
}

Write-Host "`nComprobando acceso sin contraseña:"
foreach ($ip in $nodos) {
    $r = ssh -o BatchMode=yes -o ConnectTimeout=5 "cluster@$ip" hostname
    if ($LASTEXITCODE -eq 0) { Write-Host "[OK]    $ip -> $r" } else { Write-Host "[FALLA] $ip" }
}
