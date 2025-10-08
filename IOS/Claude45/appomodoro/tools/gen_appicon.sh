#!/usr/bin/env bash
set -euo pipefail

# Navigate to the appomodoro directory
cd "$(dirname "$0")/.."

# Generate the 1024x1024 base icon
echo "🎨 Generating base app icon (1024x1024)..."
swift tools/IconGenerator.swift

SRC="appomodoro/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
DST="appomodoro/Assets.xcassets/AppIcon.appiconset"

if [ ! -f "$SRC" ]; then
    echo "❌ Base icon not found at $SRC"
    exit 1
fi

echo "🖼️  Generating app icon sizes with sips..."

# iPhone sizes
sips -z 40 40 "$SRC" --out "$DST/icon-40.png" > /dev/null 2>&1
sips -z 60 60 "$SRC" --out "$DST/icon-60.png" > /dev/null 2>&1
sips -z 58 58 "$SRC" --out "$DST/icon-58.png" > /dev/null 2>&1
sips -z 87 87 "$SRC" --out "$DST/icon-87.png" > /dev/null 2>&1
sips -z 80 80 "$SRC" --out "$DST/icon-80.png" > /dev/null 2>&1
sips -z 120 120 "$SRC" --out "$DST/icon-120.png" > /dev/null 2>&1
sips -z 180 180 "$SRC" --out "$DST/icon-180.png" > /dev/null 2>&1

# iPad sizes
sips -z 20 20 "$SRC" --out "$DST/icon-20.png" > /dev/null 2>&1
sips -z 29 29 "$SRC" --out "$DST/icon-29.png" > /dev/null 2>&1
sips -z 76 76 "$SRC" --out "$DST/icon-76.png" > /dev/null 2>&1
sips -z 152 152 "$SRC" --out "$DST/icon-152.png" > /dev/null 2>&1
sips -z 167 167 "$SRC" --out "$DST/icon-167.png" > /dev/null 2>&1

# Marketing (1024 is already created by IconGenerator.swift, just rename it)
mv "$SRC" "$DST/icon-1024.png"

echo "📝 Creating Contents.json..."

cat > "$DST/Contents.json" << 'EOF'
{
  "images" : [
    {
      "filename" : "icon-40.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "icon-60.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "filename" : "icon-58.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "icon-87.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "filename" : "icon-80.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "icon-120.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "filename" : "icon-120.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "filename" : "icon-180.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "filename" : "icon-20.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "filename" : "icon-40.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "icon-29.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "filename" : "icon-58.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "icon-40.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "filename" : "icon-80.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "icon-76.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "76x76"
    },
    {
      "filename" : "icon-152.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "filename" : "icon-167.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "filename" : "icon-1024.png",
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "✅ App icon set generated successfully!"
echo "   Base: AppIcon-1024.png"
echo "   Generated: 13 icon sizes"
echo "   Manifest: Contents.json"
