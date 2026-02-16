@echo off
setlocal

rem Dart SDK path (resolved from the current environment)
set "REAL_DART=C:\tools\dart-sdk\bin\dart.exe"

if /I "%1"=="pub" if /I "%2"=="publish" goto :pub_publish

"%REAL_DART%" %*
exit /b %ERRORLEVEL%

:pub_publish
for %%I in ("%~dp0..\..\..\..\..\..\..\..") do set "BACKEND=%%~fI"
for %%I in ("%~dp0.") do set "PKG=%%~fI"
call set "REL=%%PKG:%BACKEND%\=%%"

rem Check if caller already provided a directory override.
set "HAS_DIR="
for %%A in (%*) do (
  if /I "%%~A"=="--directory" set "HAS_DIR=1"
  if /I "%%~A"=="-C" set "HAS_DIR=1"
  if /I "%%~A:~0,12%"=="--directory=" set "HAS_DIR=1"
)

set "REST="
for /f "tokens=1,2,*" %%A in ("%*") do set "REST=%%C"

pushd "%BACKEND%" >nul
if defined HAS_DIR (
  "%REAL_DART%" pub publish %REST%
) else (
  "%REAL_DART%" pub publish %REST% --directory "%REL%"
)
set "EXITCODE=%ERRORLEVEL%"
popd >nul
exit /b %EXITCODE%
