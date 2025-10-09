import Foundation
import CoreGraphics

enum AngleMath {
    static func point(onCircleWithCenter center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
        CGPoint(
            x: center.x + CGFloat(cos(angle)) * radius,
            y: center.y + CGFloat(sin(angle)) * radius
        )
    }

    static func wrap(_ angle: Double) -> Double {
        let twoPi = Double.pi * 2
        let wrapped = angle.truncatingRemainder(dividingBy: twoPi)
        return wrapped >= 0 ? wrapped : wrapped + twoPi
    }
}
