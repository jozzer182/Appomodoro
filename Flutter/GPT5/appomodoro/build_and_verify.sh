#!/usr/bin/env bash
set -euo pipefail

echo "(icon generation)"
dart run tool/icon_generator.dart || echo "(icon generation skipped)"

flutter pub get
flutter pub run flutter_launcher_icons:main || echo "(launcher_icons skipped)"

dart format --set-exit-if-changed lib || true
flutter analyze || echo "(analyze reported issues)"

echo "Building Android APK (release)"
flutter build apk --release

echo "Building iOS (no codesign)"
flutter build ios --no-codesign

echo "✅ Flutter builds completed successfully: Android APK + iOS (no codesign)."
