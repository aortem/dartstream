# Cleanup any existing process on port 8086
Write-Host "Cleaning up port 8086..." -ForegroundColor Cyan
$existingProcess = Get-NetTCPConnection -LocalPort 8086 -ErrorAction SilentlyContinue
if ($existingProcess) {
    foreach ($p in $existingProcess) {
        Stop-Process -Id $p.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 1
}

# Run the sample server
$serverProcess = Start-Process -FilePath "dart" -ArgumentList "run example/server.dart" -PassThru -NoNewWindow

# Wait a moment for the server to start
Start-Sleep -Seconds 3

# Open the browser
Start-Process "http://localhost:8086"

# Wait for user input to exit
Write-Host "Press any key to stop the server..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Stop the server
Stop-Process -Id $serverProcess.Id -Force
