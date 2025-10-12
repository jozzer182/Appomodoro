# Appomodoro - Android Pomodoro Timer

A beautiful, feature-rich Pomodoro timer app for Android with a unique mechanical dial interface.

## Features

- **Mechanical Dial Interface**: Dual rotating number rings (seconds & minutes) with fixed selector windows
- **60 FPS Animation**: Smooth continuous rotation using Compose Canvas with `withFrameNanos`
- **Pomodoro Cycles**: Focus sessions, short breaks, and long breaks with automatic progression
- **Customizable Settings**:
  - Preset durations (25/5, 50/10) or custom durations
  - Configurable cycles before long break
  - Auto-advance between phases
  - Accent color picker
- **Notifications**: Phase completion alerts with vibration
- **State Persistence**: Settings and timer state saved with DataStore
- **Timestamp-based Logic**: No drift on background/resume

## Tech Stack

- **Language**: Kotlin
- **UI**: Jetpack Compose with Material 3
- **Architecture**: MVVM with StateFlow
- **Persistence**: DataStore (Preferences)
- **Min SDK**: 26 (Android 8.0)
- **Target SDK**: 35 (Android 15)

## Project Structure

```
app/
  src/main/
    AndroidManifest.xml
    java/com/zarabandajose/appomodoro/
      MainActivity.kt
      model/
        PomodoroPhase.kt
        PomodoroSettings.kt
        PomodoroTimerState.kt
      data/
        SettingsStore.kt
      domain/
        PomodoroEngine.kt
      ui/
        PomodoroViewModel.kt
        screens/
          HomeScreen.kt
          SettingsScreen.kt
        components/
          DialCanvas.kt
          ControlBar.kt
        theme/
          Color.kt
          Theme.kt
          Type.kt
      util/
        AngleMath.kt
    res/
      drawable/
        ic_launcher_foreground.xml
      mipmap-anydpi-v26/
        ic_launcher.xml
        ic_launcher_round.xml
      values/
        strings.xml
        ic_launcher_colors.xml
```

## Building

### Prerequisites

- Android Studio (or just the Gradle wrapper)
- JDK 11 or higher

### Build from Command Line (Windows)

```cmd
build_and_verify.bat
```

This script will:
1. Verify icon resources exist
2. Clean and build the debug APK using Gradle wrapper
3. Report build success/failure

The APK will be located at: `app\build\outputs\apk\debug\app-debug.apk`

### Build with Gradle Manually

```cmd
.\gradlew.bat clean assembleDebug
```

## Running

1. Connect an Android device or start an emulator
2. Install the APK:
   ```cmd
   adb install app\build\outputs\apk\debug\app-debug.apk
   ```
3. Launch the app from your device

## Dial Mechanics

The dial visualization uses mathematical formulas for precise rotation:

- **Seconds Ring**: `θ = -π/2 + 2π * ((elapsedSec % 60) / 60)`
  - Completes 1 full rotation per 60 seconds
- **Minutes Ring**: `θ = -π/2 + 2π * ((elapsedSec / 60) / 60)`
  - Completes 1 full rotation per 3600 seconds (1 hour)
  - Provides smooth continuous minutes movement

Fixed selector windows (left for seconds, right for minutes) create a "viewport" effect as rings rotate beneath them.

## Customization

Access settings via the gear icon:
- Adjust focus/break durations
- Change cycles before long break
- Enable/disable auto-advance
- Pick your preferred accent color
- Toggle notifications

## License

This project is part of a monorepo structure and is intended for demonstration purposes.

## Author

Built with Android/Kotlin best practices using Jetpack Compose and Material Design 3.
