#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

bash "$SCRIPT_DIR/tools/gen_appicon.sh"

xcodebuild \
  -project "$PROJECT_ROOT/appomodoro.xcodeproj" \
  -scheme "appomodoro" \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -configuration Debug \
  -quiet \
  clean build

echo "✅ xcodebuild completed successfully."
