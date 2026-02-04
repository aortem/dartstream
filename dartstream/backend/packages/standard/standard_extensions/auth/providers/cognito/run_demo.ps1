# Run this script from the package root
Write-Host "Starting DartStream Cognito Sample..." -ForegroundColor Cyan

# Check if port 8081 is in use and warn (Killing is risky without admin, so just warn)
$portInfo = Get-NetTCPConnection -LocalPort 8081 -ErrorAction SilentlyContinue
if ($portInfo) {
    Write-Host "WARNING: Port 8081 seems to be in use. If the server fails, please close other terminal windows." -ForegroundColor Yellow
}

# Navigate to app directory
Set-Location "example/cognito-app"

# Check if node_modules exists, if not install dependencies
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies... (This runs once)" -ForegroundColor Cyan
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "npm install failed!" -ForegroundColor Red
        exit 1
    }
}

# Run concurrently
# -y: yes to install
# --kill-others: if one crashes, kill the other
# --names: labels for output
Write-Host "Executing npx concurrently..."
npx -y concurrently --kill-others --names "BACKEND,FRONTEND" --prefix-colors "blue,green" "dart run ../../bin/cognito_server.dart" "npm run dev"
