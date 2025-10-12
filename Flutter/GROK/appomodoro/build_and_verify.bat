@echo off
setlocal
REM Generate icon (non-fatal if it fails)
call dart run tool/icon_generator.dart
IF ERRORLEVEL 1 echo (icon generation skipped)

call flutter pub get
REM Try to apply launcher icons (non-fatal)
call flutter pub run flutter_launcher_icons:main
IF ERRORLEVEL 1 echo (flutter_launcher_icons skipped)

REM Analyze + format check (non-fatal but print)
call flutter format --set-exit-if-changed lib
call flutter analyze || echo (analyze reported issues)

REM MUST: build the APK; if this fails, you must fix the project until it succeeds
call flutter build apk --release
IF ERRORLEVEL 1 (
  echo Build failed. You must fix all code/config until it compiles successfully.
  exit /b 1
)

echo ✅ Flutter APK build completed successfully.
endlocal