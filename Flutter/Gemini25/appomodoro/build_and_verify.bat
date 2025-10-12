@echo off
setlocal

:info
echo.
echo ============================================================================
echo %~1
echo ============================================================================
goto :eof

:run_command
echo Running: %*
%*
if %errorlevel% neq 0 (
  echo.
  echo ERROR: Command failed with exit code %errorlevel%: %*
  exit /b %errorlevel%
)
goto :eof

call :info "Generating icon..."
dart run tool/icon_generator.dart
IF ERRORLEVEL 1 echo (icon generation skipped)

call :info "Getting dependencies..."
call :run_command flutter pub get

call :info "Applying launcher icons..."
flutter pub run flutter_launcher_icons
IF ERRORLEVEL 1 echo (flutter_launcher_icons skipped)

call :info "Formatting code..."
call :run_command dart format --set-exit-if-changed .

call :info "Analyzing project..."
flutter analyze || echo (analyze reported issues)

call :info "Building release APK..."
call :run_command flutter build apk --release

call :info "Build script finished successfully."
echo.
echo ✅ Flutter APK build completed successfully.

endlocal
exit /b 0

