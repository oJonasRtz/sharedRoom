$ErrorActionPreference = 'Stop'

Write-Host 'Setting up environment variables...'

$missing = @()
foreach ($dir in @('MusicRooms.Api', 'MusicRooms.Web')) {
    if (-not (Test-Path (Join-Path $dir '.env'))) {
        Write-Host "Error: Missing .env file in $dir"
        $missing += $dir
    }
}

if ($missing.Count -gt 0) {
    $jwtSecret = -join ((1..32) | ForEach-Object { '{0:x2}' -f (Get-Random -Minimum 0 -Maximum 256) })
    $expTimeHours = 20

    "JWT_SECRET=$jwtSecret`nEXP_TIME_HOURS=$expTimeHours" | Set-Content 'MusicRooms.Api/.env'
    "EXP_TIME_HOURS=$expTimeHours" | Set-Content 'MusicRooms.Web/.env'

    Write-Host 'Environment variables set up successfully!'
}