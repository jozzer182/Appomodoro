# Appomodoro

Pomodoro timer with a mechanical-style dial featuring two concentric rotating rings (seconds outer, minutes inner) with fixed selector windows.

Builds at 60 fps and targets Android and iOS.

Build script:

Run the combined builds on macOS:

```
./build_and_verify.sh
```

This script best-effort generates an app icon with pure Dart, runs pub get, formats/analyzes, builds Android APK (release) and iOS without codesign.

