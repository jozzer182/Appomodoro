#if !canImport(UIKit)
import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

private func generateIcon() {
    let size: CGFloat = 1024
    let rect = CGRect(x: 0, y: 0, width: size, height: size)
    let colorSpace = CGColorSpaceCreateDeviceRGB()

    guard let context = CGContext(
        data: nil,
        width: Int(size),
        height: Int(size),
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else {
        fatalError("Unable to create graphics context")
    }

    context.setFillColor(red: 0.05, green: 0.05, blue: 0.08, alpha: 1)
    context.fill(rect)

    let outerRingRect = rect.insetBy(dx: 120, dy: 120)
    let innerRingRect = rect.insetBy(dx: 240, dy: 240)

    context.setStrokeColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1)
    context.setLineWidth(22)
    context.strokeEllipse(in: outerRingRect)

    context.setStrokeColor(red: 0.35, green: 0.35, blue: 0.4, alpha: 1)
    context.setLineWidth(18)
    context.strokeEllipse(in: innerRingRect)

    let tickCount = 60
    let center = CGPoint(x: size / 2, y: size / 2)
    let outerRadius = outerRingRect.width / 2

    for index in 0..<tickCount {
        let angle = Double(index) / Double(tickCount) * Double.pi * 2
        let tickLength: CGFloat = index % 5 == 0 ? 40 : 20
        let innerRadius = outerRadius - tickLength

        let startPoint = CGPoint(
            x: center.x + CGFloat(cos(angle)) * innerRadius,
            y: center.y + CGFloat(sin(angle)) * innerRadius
        )
        let endPoint = CGPoint(
            x: center.x + CGFloat(cos(angle)) * outerRadius,
            y: center.y + CGFloat(sin(angle)) * outerRadius
        )

        context.setStrokeColor(red: 0.4, green: 0.4, blue: 0.45, alpha: index % 5 == 0 ? 0.8 : 0.3)
        context.setLineWidth(index % 5 == 0 ? 6 : 2)
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.strokePath()
    }

    let accentRect = CGRect(x: center.x + 180, y: center.y - 70, width: 170, height: 140)
    let accentPath = CGPath(ellipseIn: accentRect, transform: nil)
    context.setFillColor(red: 0.95, green: 0.26, blue: 0.21, alpha: 1)
    context.addPath(accentPath)
    context.fillPath()

    let path = "Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
    let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(path)

    do {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    } catch {
        fatalError("Unable to create icon directory: \(error.localizedDescription)")
    }

    guard let image = context.makeImage() else {
        fatalError("Failed to make CGImage")
    }

    guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        fatalError("Unable to create image destination")
    }

    CGImageDestinationAddImage(destination, image, nil)
    if !CGImageDestinationFinalize(destination) {
        fatalError("Failed to write image to \(url.path)")
    }

    print("Generated icon at \(url.path)")
}

generateIcon()
#endif
