//
//  AngleMath.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import Foundation
import CoreGraphics

/// Utility functions for angle calculations in the dial view
struct AngleMath {
    
    /// Calculate the rotation angle for seconds ring
    /// - Parameter elapsed: elapsed time in seconds
    /// - Returns: angle in radians (starts at top, -π/2, rotates clockwise)
    static func secondsAngle(elapsed: TimeInterval) -> Double {
        let secondsFrac = elapsed.truncatingRemainder(dividingBy: 60)  // 0..<60
        return -Double.pi / 2 + 2 * Double.pi * (secondsFrac / 60.0)   // 1 full turn per 60s
    }
    
    /// Calculate the rotation angle for minutes ring
    /// - Parameter elapsed: elapsed time in seconds
    /// - Returns: angle in radians (starts at top, -π/2, rotates clockwise)
    static func minutesAngle(elapsed: TimeInterval) -> Double {
        let minutesFrac = (elapsed / 60.0).truncatingRemainder(dividingBy: 60)  // 0..<60 minutes
        return -Double.pi / 2 + 2 * Double.pi * (minutesFrac / 60.0)            // 1 full turn per 3600s
    }
    
    /// Get position on circle for given angle and radius
    /// - Parameters:
    ///   - angle: angle in radians
    ///   - radius: radius of the circle
    ///   - center: center point of the circle
    /// - Returns: CGPoint on the circumference
    static func pointOnCircle(angle: Double, radius: CGFloat, center: CGPoint) -> CGPoint {
        let x = center.x + radius * CGFloat(cos(angle))
        let y = center.y + radius * CGFloat(sin(angle))
        return CGPoint(x: x, y: y)
    }
    
    /// Format time interval as MM:SS
    /// - Parameter interval: time in seconds
    /// - Returns: formatted string "MM:SS"
    static func formatTime(_ interval: TimeInterval) -> (minutes: String, seconds: String) {
        let totalSeconds = max(0, Int(interval.rounded()))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return (String(format: "%02d", minutes), String(format: "%02d", seconds))
    }
    
    /// Get the current value that should appear in selector window
    /// - Parameters:
    ///   - elapsed: elapsed time
    ///   - isSeconds: true for seconds ring, false for minutes ring
    /// - Returns: the number (0-59) that appears in the selector
    static func currentDisplayValue(elapsed: TimeInterval, isSeconds: Bool) -> Int {
        if isSeconds {
            return Int(elapsed.truncatingRemainder(dividingBy: 60))
        } else {
            return Int((elapsed / 60.0).truncatingRemainder(dividingBy: 60))
        }
    }
    
    /// Normalize angle to 0...2π range
    static func normalizeAngle(_ angle: Double) -> Double {
        var normalized = angle.truncatingRemainder(dividingBy: 2 * .pi)
        if normalized < 0 {
            normalized += 2 * .pi
        }
        return normalized
    }
}
