# Appomodoro

A beautiful Pomodoro timer app for iOS with a unique dual-ring mechanical dial interface.

## Features

- **Dual-Ring Rotating Dial**: Two concentric, continuously rotating number rings (seconds and minutes) with fixed selector windows
- **60 FPS Animation**: Smooth, continuous motion using Canvas + TimelineView
- **Pomodoro Timer**: Focus sessions, short breaks, and long breaks
- **Customizable**: Adjust durations, cycles, and accent colors
- **Notifications**: Local notifications when phases complete
- **Haptic Feedback**: Subtle haptic responses for interactions
- **Persistence**: Saves state and settings using UserDefaults
- **Background Support**: Handles app backgrounding without timer drift
- **Accessibility**: VoiceOver support with time announcements

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Building

Run the build script from terminal:

```bash
./build_and_verify.sh
```

Or build with xcodebuild directly:

```bash
xcodebuild \
  -scheme "appomodoro" \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -configuration Debug \
  clean build
```

## Architecture

- **MVVM Pattern**: Clean separation of concerns
- **SwiftUI**: Modern declarative UI
- **Combine**: Reactive state management
- **Canvas**: High-performance custom drawing for the dial
- **TimelineView**: Display-synchronized animations

### Project Structure

```
appomodoro/
├── Models/              # Data models (Phase, Settings, State)
├── ViewModel/           # Business logic (PomodoroViewModel)
├── Views/               # UI components (DialView, ControlBar, etc.)
├── Services/            # System integrations (Notifications, Haptics)
├── Utils/               # Helper functions (AngleMath)
└── Assets.xcassets/     # Images and app icons
```

## Design

The dial interface features:

- Black/graphite background with high-contrast white numerals
- Outer ring: 60 seconds rotating clockwise (1 revolution per minute)
- Inner ring: 60 minutes rotating clockwise (1 revolution per hour)
- Left selector window: Shows current second
- Right selector window: Shows current minute
- Center display: Large minutes + accent-colored seconds badge
- 60 tick marks on outer ring (longer every 5 seconds)
- SF Pro Rounded typography

## Presets

- **25/5**: 25-minute focus, 5-minute breaks (classic Pomodoro)
- **50/10**: 50-minute focus, 10-minute breaks (extended sessions)
- **Custom**: Configure your own durations

## License

Copyright © 2025 Jose Zarabanda. All rights reserved.
