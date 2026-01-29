@echo off
setlocal

rem Dart SDK path (resolved from the current environment)
set "REAL_DART=C:\tools\dart-sdk\bin\dart.exe"

if /I "%1"=="pub" if /I "%2"=="publish" (
  for %%I in ("%~dp0..\..\..\..\..\..\..") do set "BACKEND=%%~fI"
  for %%I in ("%~dp0.") do set "PKG=%%~fI"
  set "REL=%PKG:%BACKEND%\=%"

  rem Check if caller already provided a directory override.
  set "HAS_DIR="
  for %%A in (%*) do (
    if /I "%%~A"=="--directory" set "HAS_DIR=1"
    if /I "%%~A"=="-C" set "HAS_DIR=1"
    if /I "%%~A:~0,12%"=="--directory=" set "HAS_DIR=1"
  )

  shift
  shift
  pushd "%BACKEND%" >nul
  if defined HAS_DIR (
    "%REAL_DART%" pub publish %*
  ) else (
    "%REAL_DART%" pub publish %* --directory "%REL%"
  )
  set "EXITCODE=%ERRORLEVEL%"
  popd >nul
  exit /b %EXITCODE%
)

"%REAL_DART%" %*
exit /b %ERRORLEVEL%
