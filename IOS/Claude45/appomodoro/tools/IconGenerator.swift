#!/usr/bin/env swift

import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

// MARK: - Icon Generator

let width = 1024
let height = 1024
let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

guard let context = CGContext(
    data: nil,
    width: width,
    height: height,
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: colorSpace,
    bitmapInfo: bitmapInfo
) else {
    print("Failed to create graphics context")
    exit(1)
}

let center = CGPoint(x: CGFloat(width) / 2, y: CGFloat(height) / 2)
let maxRadius = min(CGFloat(width), CGFloat(height)) / 2 - 60

// Background - dark graphite/black
context.setFillColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1.0)
context.fill(CGRect(x: 0, y: 0, width: width, height: height))

// Outer ring (seconds ring reference)
let outerRingRadius = maxRadius
context.setStrokeColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
context.setLineWidth(3)
context.addArc(
    center: center,
    radius: outerRingRadius,
    startAngle: 0,
    endAngle: 2 * .pi,
    clockwise: false
)
context.strokePath()

// Inner ring (minutes ring reference)
let innerRingRadius = maxRadius * 0.7
context.setStrokeColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
context.setLineWidth(2.5)
context.addArc(
    center: center,
    radius: innerRingRadius,
    startAngle: 0,
    endAngle: 2 * .pi,
    clockwise: false
)
context.strokePath()

// Draw subtle tick marks around outer ring
for i in 0..<12 {
    let angle = CGFloat(i) * (2 * .pi / 12) - .pi / 2
    let innerRadius = outerRingRadius - 15
    let outerRadius = outerRingRadius
    
    let innerPoint = CGPoint(
        x: center.x + innerRadius * cos(angle),
        y: center.y + innerRadius * sin(angle)
    )
    let outerPoint = CGPoint(
        x: center.x + outerRadius * cos(angle),
        y: center.y + outerRadius * sin(angle)
    )
    
    context.setStrokeColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4)
    context.setLineWidth(2)
    context.move(to: innerPoint)
    context.addLine(to: outerPoint)
    context.strokePath()
}

// Accent color oval badge on the right (representing seconds badge)
let accentColor = (red: 1.0, green: 0.42, blue: 0.42) // #FF6B6B
let badgeX = center.x + maxRadius * 0.35
let badgeY = center.y
let badgeWidth: CGFloat = 80
let badgeHeight: CGFloat = 50

context.setFillColor(red: accentColor.red, green: accentColor.green, blue: accentColor.blue, alpha: 0.3)
let badgePath = CGPath(
    roundedRect: CGRect(
        x: badgeX - badgeWidth / 2,
        y: badgeY - badgeHeight / 2,
        width: badgeWidth,
        height: badgeHeight
    ),
    cornerWidth: badgeHeight / 2,
    cornerHeight: badgeHeight / 2,
    transform: nil
)
context.addPath(badgePath)
context.fillPath()

context.setStrokeColor(red: accentColor.red, green: accentColor.green, blue: accentColor.blue, alpha: 0.9)
context.setLineWidth(2.5)
context.addPath(badgePath)
context.strokePath()

// Small center dot
context.setFillColor(red: accentColor.red, green: accentColor.green, blue: accentColor.blue, alpha: 0.5)
context.fillEllipse(in: CGRect(
    x: center.x - 8,
    y: center.y - 8,
    width: 16,
    height: 16
))

// Create image and save
guard let image = context.makeImage() else {
    print("Failed to create image")
    exit(1)
}

// Determine output path
let currentDir = FileManager.default.currentDirectoryPath
let outputPath = "\(currentDir)/appomodoro/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
let outputURL = URL(fileURLWithPath: outputPath)

// Ensure directory exists
try? FileManager.default.createDirectory(
    at: outputURL.deletingLastPathComponent(),
    withIntermediateDirectories: true
)

// Save PNG
guard let destination = CGImageDestinationCreateWithURL(
    outputURL as CFURL,
    UTType.png.identifier as CFString,
    1,
    nil
) else {
    print("Failed to create image destination")
    exit(1)
}

CGImageDestinationAddImage(destination, image, nil)

if CGImageDestinationFinalize(destination) {
    print("✅ Generated app icon: \(outputPath)")
} else {
    print("❌ Failed to save image")
    exit(1)
}
