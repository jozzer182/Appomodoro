#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting Appomodoro build verification..."
echo ""

# Best-effort icon generation (never blocks builds)
echo "📱 Generating app icon..."
if dart run tool/icon_generator.dart; then
    echo "✅ Icon generated successfully"
else
    echo "⚠️  Icon generation skipped (continuing anyway)"
fi
echo ""

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get
echo ""

# Run flutter_launcher_icons (best effort)
echo "🎨 Configuring launcher icons..."
if flutter pub run flutter_launcher_icons:main; then
    echo "✅ Launcher icons configured"
else
    echo "⚠️  Launcher icons skipped (continuing anyway)"
fi
echo ""

# Format check (non-fatal)
echo "🔍 Checking code formatting..."
if flutter format --set-exit-if-changed lib; then
    echo "✅ Code is formatted correctly"
else
    echo "⚠️  Code formatting issues found (non-fatal)"
fi
echo ""

# Analyze (non-fatal)
echo "🔍 Running static analysis..."
if flutter analyze; then
    echo "✅ Static analysis passed"
else
    echo "⚠️  Static analysis reported issues (non-fatal)"
fi
echo ""

# ANDROID BUILD - MUST SUCCEED
echo "🤖 Building Android APK (release)..."
flutter build apk --release
echo "✅ Android APK built successfully!"
echo ""

# iOS BUILD - MUST SUCCEED
echo "🍎 Building iOS (no codesign)..."
# First, ensure CocoaPods are up to date
cd ios
echo "📦 Installing/updating CocoaPods..."
pod install --repo-update
cd ..

flutter build ios --no-codesign
echo "✅ iOS build completed successfully!"
echo ""

echo "🎉 =============================================="
echo "🎉 ALL BUILDS COMPLETED SUCCESSFULLY!"
echo "🎉 =============================================="
echo ""
echo "📦 Build artifacts:"
echo "   - Android APK: build/app/outputs/flutter-apk/app-release.apk"
echo "   - iOS: build/ios/iphoneos/Runner.app"
echo ""
