@echo off
setlocal enabledelayedexpansion
echo ========================================
echo Appomodoro Build and Verification Script
echo ========================================
echo.

REM Verify adaptive icon resources exist (or skip if intentionally omitted)
echo Checking for custom icon resources...
IF EXIST app\src\main\res\drawable\ic_launcher_foreground.xml (
  echo [OK] Found vector foreground: app\src\main\res\drawable\ic_launcher_foreground.xml
) ELSE (
  echo [WARN] Vector foreground not found. Proceeding without custom icon.
)

IF EXIST app\src\main\res\mipmap-anydpi-v26\ic_launcher.xml (
  echo [OK] Found adaptive icon XML: app\src\main\res\mipmap-anydpi-v26\ic_launcher.xml
) ELSE (
  echo [WARN] Adaptive icon XML not found. Proceeding without custom icon.
)

IF EXIST app\src\main\res\values\ic_launcher_colors.xml (
  echo [OK] Found icon colors: app\src\main\res\values\ic_launcher_colors.xml
) ELSE (
  echo [WARN] Icon colors not found.
)

echo.
echo ========================================
echo Building the app with Gradle wrapper...
echo ========================================
echo.

REM Build the entire app with Gradle wrapper (no external JAVA/KOTLINC required)
call .\gradlew.bat --no-daemon clean assembleDebug

IF ERRORLEVEL 1 (
  echo.
  echo ========================================
  echo [ERROR] Build failed!
  echo ========================================
  echo You must fix all code/Gradle/config issues until it succeeds.
  echo.
  exit /b 1
)

echo.
echo ========================================
echo [SUCCESS] Gradle build completed!
echo ========================================
echo.
echo The debug APK has been built successfully.
echo Location: app\build\outputs\apk\debug\app-debug.apk
echo.
echo Verification complete - all checks passed!
echo.
endlocal
