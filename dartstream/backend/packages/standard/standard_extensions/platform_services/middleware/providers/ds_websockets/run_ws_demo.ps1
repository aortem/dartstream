# PowerShell Script to run the DartStream WebSocket Demo
Write-Host 'Checking example directory...'
if (Test-Path 'example') {
    Push-Location 'example'
    Write-Host 'Installing dependencies...'
    dart pub get
    Write-Host 'Starting server...'
    dart server.dart
    Pop-Location
} else {
    Write-Host 'Error: Please run this script from the ds_websockets package directory.'
}
