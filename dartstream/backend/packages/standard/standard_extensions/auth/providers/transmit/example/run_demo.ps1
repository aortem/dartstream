# PowerShell script to run Transmit Auth Demo
# This script runs both backend and frontend together

Write-Host "Starting Transmit Auth Demo..." -ForegroundColor Cyan
Write-Host ""

# Check if dart is installed
if (-not (Get-Command dart -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Dart is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Install Dart dependencies
Write-Host "Installing Dart dependencies..." -ForegroundColor Yellow
dart pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install Dart dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "SUCCESS: Dependencies installed" -ForegroundColor Green
Write-Host ""

# Start the server
Write-Host "Starting Transmit Auth Server..." -ForegroundColor Cyan
Write-Host "Backend will serve both API and frontend" -ForegroundColor Yellow
Write-Host "TIP: Open http://localhost:4000 in your browser" -ForegroundColor Green
Write-Host ""

dart run bin/transmit_server.dart
