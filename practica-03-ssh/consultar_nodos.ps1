# Práctica 3 — Ejecuta un comando en los 4 nodos del grupo por SSH (Windows).
# Uso:  powershell -File consultar_nodos.ps1 -Grupo a -Comando "uptime"
param(
    [Parameter(Mandatory)][ValidateSet('a', 'b')][string]$Grupo,
    [string]$Comando = 'hostname; uptime'
)

$base = if ($Grupo -eq 'a') { 10 } else { 20 }
foreach ($i in 0..3) {
    $ip = "192.168.20.$($base + $i)"
    Write-Host "--- $ip ---"
    ssh -o BatchMode=yes -o ConnectTimeout=5 "cluster@$ip" $Comando
    if ($LASTEXITCODE -ne 0) { Write-Host "[FALLA] $ip no respondió" }
}
