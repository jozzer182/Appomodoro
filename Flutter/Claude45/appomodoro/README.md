# Appomodoro

A beautiful Pomodoro timer app built with Flutter, featuring a unique concentric rotating rings dial that displays time at 60fps.

## Features

- **Unique 60fps Dial**: Two concentric rotating number rings (seconds outer, minutes inner) with fixed selector windows
- **Pomodoro Workflow**: Focus, Short Break, Long Break phases with customizable durations
- **Presets**: 25/5 and 50/10 minute presets, plus custom durations
- **Auto-advance**: Automatically advance to next phase after completion
- **Local Notifications**: Get notified when a phase completes
- **State Persistence**: App state is saved and restored, even after closing
- **Responsive Design**: Optimized for phones, tablets, and iPads
- **Theme Customization**: Choose from 8 accent colors
- **Framework-Neutral**: Modern design that feels native on both iOS and Android

## Technical Details

- **Flutter**: Latest stable version
- **Dart**: Latest stable version
- **State Management**: ChangeNotifier/ValueNotifier
- **Persistence**: shared_preferences
- **Notifications**: flutter_local_notifications
- **Platform Support**:
  - Android: minSDK 26+ (Android 8.0+)
  - iOS: iOS 13+

## Architecture

```
lib/
  app.dart                      # Main app widget
  main.dart                     # Entry point
  core/
    theme.dart                  # App theme and colors
    responsive.dart             # Responsive layout utilities
  features/pomodoro/
    data/
      preferences.dart          # Settings & state persistence
      notification_service.dart # Local notifications
    domain/
      models.dart              # Data models (Phase, Settings, State)
      engine.dart              # Timer logic with timestamp-based calculations
    presentation/
      pages/
        home_page.dart         # Main timer screen
        settings_page.dart     # Settings screen
      widgets/
        dial_painter.dart      # Custom 60fps dial with rotating rings
        control_bar.dart       # Timer controls
tool/
  icon_generator.dart          # Pure Dart app icon generator
```

## Building

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK (latest stable)
- For Android: Android SDK with API 26+
- For iOS: Xcode 12+ and CocoaPods

### Build Both Platforms

On macOS, run the verification script:

```bash
chmod +x build_and_verify.sh
./build_and_verify.sh
```

This script will:
1. Generate the app icon (pure Dart, no external tools)
2. Install dependencies
3. Configure launcher icons
4. Format and analyze code
5. Build Android APK (release)
6. Build iOS (no codesign)

### Build Individually

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --no-codesign
```

## Running

```bash
flutter run
```

## Dial Motion Specification

The dial features two concentric rings that rotate continuously:

- **Seconds Ring (Outer)**: 60 numerals (00-59) rotating clockwise, completing one full revolution per 60 seconds
- **Minutes Ring (Inner)**: 60 numerals (00-59) rotating clockwise, completing one full revolution per 60 minutes
- **Selector Windows**: Fixed rounded windows reveal the current second (LEFT) and minute (RIGHT)
- **Center Display**: Large minutes + small seconds badge with accent color
- **Frame Rate**: Smooth 60fps animation using Ticker

### Math

- Seconds angle: `θ_s = -π/2 + 2π * ((elapsed_sec % 60) / 60)`
- Minutes angle: `θ_m = -π/2 + 2π * ((elapsed_sec / 60) / 60)`

## License

This project is created as a demonstration of Flutter capabilities.

## Monorepo Structure

This project lives in a monorepo:
```
pomodoro/                      # Root repo
  Flutter/
    Claude45/
      appomodoro/              # This Flutter app
```

The `.gitignore` is configured to preserve all source files while excluding build artifacts and dependencies.

