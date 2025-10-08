#!/usr/bin/env bash
set -euo pipefail

# Navigate to the script directory
cd "$(dirname "$0")"

echo "🔧 Appomodoro Build & Verify Script"
echo "===================================="

# Generate app icons first
echo ""
echo "📱 Step 1: Generating app icons..."
bash tools/gen_appicon.sh

# Build the project
echo ""
echo "🏗️  Step 2: Building with xcodebuild..."
xcodebuild \
  -scheme "appomodoro" \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -configuration Debug \
  -quiet \
  clean build

echo ""
echo "✅ xcodebuild completed successfully."
echo ""
echo "🎉 All checks passed! Appomodoro is ready."
