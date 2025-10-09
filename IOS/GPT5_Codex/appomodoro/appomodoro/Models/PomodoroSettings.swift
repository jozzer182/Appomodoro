import SwiftUI

struct PomodoroSettings: Equatable, Codable {
    var focusMinutes: Int
    var shortBreakMinutes: Int
    var longBreakMinutes: Int
    var cyclesBeforeLongBreak: Int
    var autoAdvance: Bool
    var accentColorHex: String

    static let `default` = PomodoroSettings(
        focusMinutes: 25,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
        cyclesBeforeLongBreak: 4,
        autoAdvance: true,
        accentColorHex: Color.accentColor.toHexString()
    )

    func duration(for phase: PomodoroPhase) -> TimeInterval {
        let minutes: Int
        switch phase {
        case .focus:
            minutes = focusMinutes
        case .shortBreak:
            minutes = shortBreakMinutes
        case .longBreak:
            minutes = longBreakMinutes
        }
        return TimeInterval(minutes * 60)
    }

    func accentColor() -> Color {
        Color(hex: accentColorHex) ?? .accentColor
    }

    func updatingAccentColor(_ color: Color) -> PomodoroSettings {
        var copy = self
        copy.accentColorHex = color.toHexString()
        return copy
    }
}

extension Color {
    init?(hex: String) {
        var sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if sanitized.count == 6 {
            sanitized.append("FF")
        }
        guard sanitized.count == 8,
              let value = UInt64(sanitized, radix: 16) else {
            return nil
        }
        let r = Double((value >> 24) & 0xFF) / 255.0
        let g = Double((value >> 16) & 0xFF) / 255.0
        let b = Double((value >> 8) & 0xFF) / 255.0
        let a = Double(value & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    func toHexString() -> String {
        guard let components = cgColor?.components, components.count >= 3 else {
            return "FF3B30"
        }
        let r = Int(round(components[0] * 255))
        let g = Int(round(components[1] * 255))
        let b = Int(round(components[2] * 255))
        let a = Int(round((components.count >= 4 ? components[3] : 1.0) * 255))
        return String(format: "%02X%02X%02X%02X", r, g, b, a)
    }
}
