//
//  PomodoroSettings.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import SwiftUI

/// User-configurable settings for Pomodoro sessions
struct PomodoroSettings: Codable, Equatable {
    var focusDuration: TimeInterval       // in seconds (default 25*60)
    var shortBreakDuration: TimeInterval  // in seconds (default 5*60)
    var longBreakDuration: TimeInterval   // in seconds (default 15*60)
    var cyclesToLongBreak: Int            // number of focus sessions before long break (default 4)
    var autoAdvance: Bool                 // automatically start next phase
    var accentColorHex: String            // hex color for accent (e.g., "#FF6B6B")
    
    static let `default` = PomodoroSettings(
        focusDuration: 25 * 60,
        shortBreakDuration: 5 * 60,
        longBreakDuration: 15 * 60,
        cyclesToLongBreak: 4,
        autoAdvance: false,
        accentColorHex: "#FF6B6B"
    )
    
    static let preset25_5 = PomodoroSettings(
        focusDuration: 25 * 60,
        shortBreakDuration: 5 * 60,
        longBreakDuration: 15 * 60,
        cyclesToLongBreak: 4,
        autoAdvance: false,
        accentColorHex: "#FF6B6B"
    )
    
    static let preset50_10 = PomodoroSettings(
        focusDuration: 50 * 60,
        shortBreakDuration: 10 * 60,
        longBreakDuration: 30 * 60,
        cyclesToLongBreak: 4,
        autoAdvance: false,
        accentColorHex: "#FF6B6B"
    )
    
    var accentColor: Color {
        Color(hex: accentColorHex) ?? .red
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(Float(r * 255)),
                     lroundf(Float(g * 255)),
                     lroundf(Float(b * 255)))
    }
}
