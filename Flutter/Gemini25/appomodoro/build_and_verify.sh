#!/usr/bin/env bash
set -euo pipefail

# Generate icon (best-effort)
dart run tool/icon_generator.dart || echo "(icon generation skipped)"
flutter pub get
flutter pub run flutter_launcher_icons:main || echo "(launcher_icons skipped)"

# Analyze (non-fatal), then build
flutter format . || true
flutter analyze || echo "(analyze reported issues)"

# MUST pass:
flutter build apk --release
echo "✅ Flutter APK build completed successfully."