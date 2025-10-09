import Foundation

enum PomodoroPhase: String, CaseIterable, Identifiable, Codable {
    case focus
    case shortBreak
    case longBreak

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }

    var voiceOverDescription: String {
        switch self {
        case .focus:
            return "Focus session"
        case .shortBreak:
            return "Short break"
        case .longBreak:
            return "Long break"
        }
    }
}
