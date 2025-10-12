# Android Pomodoro (GPT5)

This module implements a Compose-based Pomodoro timer with a mechanical dial and full Windows build support.

## Build and Verify

Run the provided batch script from the module root (`android-GPT5/`):

```
build_and_verify.bat
```

The script locates the adaptive icon resources (if present) and invokes the Gradle wrapper with `clean assembleDebug`.

## Features

- Jetpack Compose UI with a 60 fps mechanical dial
- MVVM architecture with `ViewModel` and `StateFlow`
- DataStore-backed settings and accent color personalization
- AlarmManager-driven notifications and subtle vibration on phase completion
- Pomodoro engine supporting focus, short/long breaks, custom durations, auto-advance, and cycle tracking

## Project Layout

Key sources live under `app/src/main/java/com/zarabandajose/appomodoro/`:

- `App.kt` — application entry point & notification channel setup
- `data/SettingsStore.kt` — DataStore preferences wrapper
- `domain/PomodoroEngine.kt` — core timing & phase logic
- `ui/` — Activity, screens, Compose components, and theming
- `util/` — math helpers, alarm scheduling, and notifications

Resources (strings, themes, adaptive icon vector, colors) are under `app/src/main/res/`.
