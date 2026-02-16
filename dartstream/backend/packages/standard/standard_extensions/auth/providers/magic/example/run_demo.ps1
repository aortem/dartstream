$ErrorActionPreference = "Stop"

# Use script root as base
$baseDir = $PSScriptRoot

# Backend Setup
Write-Host "Setting up Backend..." -ForegroundColor Green
Set-Location $baseDir
dart pub get

# Frontend Setup
Write-Host "Setting up Frontend..." -ForegroundColor Green
$frontendDir = Join-Path $baseDir "magic-app"
Set-Location $frontendDir

if (-not (Test-Path "node_modules")) {
    Write-Host "Installing npm dependencies..."
    npm install
    npm install magic-sdk
}

# Start Backend
Write-Host "Starting Backend Server..." -ForegroundColor Cyan
$backendJob = Start-Job -ScriptBlock {
    param($dir)
    Set-Location $dir
    dart run server.dart
} -ArgumentList $baseDir

Write-Host "Backend started in background job (ID: $($backendJob.Id))."

# Start Frontend
Write-Host "Starting Frontend..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop both servers."

try {
    npm run dev
} finally {
    Write-Host "Stopping Backend..."
    Stop-Job $backendJob
    Remove-Job $backendJob
}
