# Appomodoro (iOS)

High-fidelity Pomodoro timer for iOS featuring a dual-ring mechanical dial rendered at 60 FPS with SwiftUI Canvas.

## Features

- Continuous dual-ring dial for seconds (outer) and minutes (inner) with fixed selector windows
- Presets for 25/5, 50/10, and fully custom focus & break durations
- Auto-advance option with long break every configured focus cycle
- Accent color customization with persistence and AA-compliant contrast
- Local notifications on phase completion and subtle haptic feedback
- State persistence backed by timestamps to avoid drift across backgrounding

## Project Structure

```
appomodoro/
├── AppomodoroApp.swift
├── Models/
├── ViewModel/
├── Views/
├── Services/
├── Utils/
├── tools/
└── Assets.xcassets/
```

## Build & Verification

Use the provided helper script to regenerate the app icons and perform a clean Xcode build targeting the iPhone 16 simulator:

```bash
./build_and_verify.sh
```

The script will:

1. Regenerate the vector-inspired 1024×1024 icon and derive all required sizes with `sips`.
2. Run `xcodebuild` with the `appomodoro` scheme (Debug) and halt on the first failure.

## Requirements

- Xcode 16+
- iOS 17 SDK

## Notes

- Icon generation is deterministic and safe for CI environments.
- No secrets are committed; `.env` files are ignored at the repo root.
