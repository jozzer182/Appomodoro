#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

SRC="Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
DST="Assets.xcassets/AppIcon.appiconset"

swift "$SCRIPT_DIR/IconGenerator.swift"

if [[ ! -f "$SRC" ]]; then
  echo "❌ Base icon not found at $SRC"
  exit 1
fi

declare -a ICON_SPECS=(
  "iphone 20x20 2 40 icon-40-iphone-2x.png"
  "iphone 20x20 3 60 icon-60-iphone-3x.png"
  "iphone 29x29 2 58 icon-58-iphone-2x.png"
  "iphone 29x29 3 87 icon-87-iphone-3x.png"
  "iphone 40x40 2 80 icon-80-iphone-2x.png"
  "iphone 40x40 3 120 icon-120-iphone-3x.png"
  "iphone 60x60 2 120 icon-120-iphone-2x.png"
  "iphone 60x60 3 180 icon-180-iphone-3x.png"
  "ipad 20x20 1 20 icon-20-ipad-1x.png"
  "ipad 20x20 2 40 icon-40-ipad-2x.png"
  "ipad 29x29 1 29 icon-29-ipad-1x.png"
  "ipad 29x29 2 58 icon-58-ipad-2x.png"
  "ipad 40x40 1 40 icon-40-ipad-1x.png"
  "ipad 40x40 2 80 icon-80-ipad-2x.png"
  "ipad 76x76 1 76 icon-76-ipad-1x.png"
  "ipad 76x76 2 152 icon-152-ipad-2x.png"
  "ipad 83.5x83.5 2 167 icon-167-ipad-2x.png"
)

for spec in "${ICON_SPECS[@]}"; do
  read -r idiom size scale pixels filename <<<"$spec"
  sips -s format png -z "$pixels" "$pixels" "$SRC" --out "$DST/$filename" >/dev/null
done

cat >"$DST/Contents.json" <<'JSON'
{
  "images": [
    {
      "idiom": "iphone",
      "size": "20x20",
      "scale": "2x",
      "filename": "icon-40-iphone-2x.png"
    },
    {
      "idiom": "iphone",
      "size": "20x20",
      "scale": "3x",
      "filename": "icon-60-iphone-3x.png"
    },
    {
      "idiom": "iphone",
      "size": "29x29",
      "scale": "2x",
      "filename": "icon-58-iphone-2x.png"
    },
    {
      "idiom": "iphone",
      "size": "29x29",
      "scale": "3x",
      "filename": "icon-87-iphone-3x.png"
    },
    {
      "idiom": "iphone",
      "size": "40x40",
      "scale": "2x",
      "filename": "icon-80-iphone-2x.png"
    },
    {
      "idiom": "iphone",
      "size": "40x40",
      "scale": "3x",
      "filename": "icon-120-iphone-3x.png"
    },
    {
      "idiom": "iphone",
      "size": "60x60",
      "scale": "2x",
      "filename": "icon-120-iphone-2x.png"
    },
    {
      "idiom": "iphone",
      "size": "60x60",
      "scale": "3x",
      "filename": "icon-180-iphone-3x.png"
    },
    {
      "idiom": "ipad",
      "size": "20x20",
      "scale": "1x",
      "filename": "icon-20-ipad-1x.png"
    },
    {
      "idiom": "ipad",
      "size": "20x20",
      "scale": "2x",
      "filename": "icon-40-ipad-2x.png"
    },
    {
      "idiom": "ipad",
      "size": "29x29",
      "scale": "1x",
      "filename": "icon-29-ipad-1x.png"
    },
    {
      "idiom": "ipad",
      "size": "29x29",
      "scale": "2x",
      "filename": "icon-58-ipad-2x.png"
    },
    {
      "idiom": "ipad",
      "size": "40x40",
      "scale": "1x",
      "filename": "icon-40-ipad-1x.png"
    },
    {
      "idiom": "ipad",
      "size": "40x40",
      "scale": "2x",
      "filename": "icon-80-ipad-2x.png"
    },
    {
      "idiom": "ipad",
      "size": "76x76",
      "scale": "1x",
      "filename": "icon-76-ipad-1x.png"
    },
    {
      "idiom": "ipad",
      "size": "76x76",
      "scale": "2x",
      "filename": "icon-152-ipad-2x.png"
    },
    {
      "idiom": "ipad",
      "size": "83.5x83.5",
      "scale": "2x",
      "filename": "icon-167-ipad-2x.png"
    },
    {
      "idiom": "ios-marketing",
      "size": "1024x1024",
      "scale": "1x",
      "filename": "AppIcon-1024.png"
    }
  ],
  "info": {
    "version": 1,
    "author": "xcode"
  }
}
JSON

echo "✅ App icon set generated"
