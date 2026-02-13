#!/usr/bin/env pwsh
# Stytch Auth Demo - Unified Launcher
# This script starts the backend server which also serves the frontend

Write-Host "🚀 Stytch Authentication Demo Launcher" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Check if dart is installed
if (-not (Get-Command dart -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: Dart SDK not found. Please install Dart first." -ForegroundColor Red
    exit 1
}

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
dart pub get 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dependencies installed" -ForegroundColor Green
Write-Host ""

# Start backend server (which also serves frontend)
Write-Host "🔥 Starting Stytch Auth Demo Server..." -ForegroundColor Yellow
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 The server will start on http://localhost:8082" -ForegroundColor White
Write-Host "💡 Your browser will open automatically" -ForegroundColor White
Write-Host "💡 Press Ctrl+C to stop the server" -ForegroundColor White
Write-Host ""
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Wait a moment then open browser
Start-Job -ScriptBlock {
    Start-Sleep -Seconds 3
    Start-Process "http://localhost:8082"
} | Out-Null

# Run the server (this will block until Ctrl+C)
dart run bin/stytch_server.dart
