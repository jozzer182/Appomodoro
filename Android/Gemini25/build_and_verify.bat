@echo off
setlocal enabledelayedexpansion
REM Verify adaptive icon resources exist (or skip if intentionally omitted)
IF EXIST app\src\main\res\drawable\ic_launcher_foreground.xml (
  echo Found vector foreground.
) ELSE (
  echo Vector foreground not found. Proceeding without custom icon.
)

IF EXIST app\src\main\res\mipmap-anydpi-v26\ic_launcher.xml (
  echo Found adaptive icon XML.
) ELSE (
  echo Adaptive icon XML not found. Proceeding without custom icon.
)

REM Build the entire app with Gradle wrapper (no external JAVA/KOTLINC required)
call .\gradlew.bat --no-daemon clean assembleDebug
IF ERRORLEVEL 1 (
  echo Build failed. You must fix all code/Gradle/config issues until it succeeds.
  exit /b 1
)

echo ✅ Gradle build (assembleDebug) completed successfully.
endlocal
