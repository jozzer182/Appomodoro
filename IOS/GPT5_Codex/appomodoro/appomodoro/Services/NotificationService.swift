import Foundation
import UserNotifications

@MainActor
final class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()
    private var hasRequestedAuthorization = false

    private init() {}

    func requestAuthorizationIfNeeded() async {
        guard !hasRequestedAuthorization else { return }
        let current = await center.notificationSettings()
        hasRequestedAuthorization = true

        guard current.authorizationStatus == .notDetermined else { return }
        do {
            let success = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if !success {
                hasRequestedAuthorization = false
            }
        } catch {
            hasRequestedAuthorization = false
        }
    }

    func schedulePhaseEndNotification(phase: PomodoroPhase, fireIn seconds: TimeInterval, settings: PomodoroSettings) {
        guard seconds > 0 else { return }
        let content = UNMutableNotificationContent()
        content.title = "\(phase.displayName) completed"
        content.body = nextPhaseMessage(for: phase, settings: settings)
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(
            identifier: "pomodoro.phase.end",
            content: content,
            trigger: trigger
        )

        center.removePendingNotificationRequests(withIdentifiers: ["pomodoro.phase.end"])
        center.add(request)
    }

    func cancelAllScheduled() {
        center.removePendingNotificationRequests(withIdentifiers: ["pomodoro.phase.end"])
    }

    private func nextPhaseMessage(for phase: PomodoroPhase, settings: PomodoroSettings) -> String {
        switch phase {
        case .focus:
            return "Time for a break!"
        case .shortBreak:
            return "Ready for another focus session?"
        case .longBreak:
            return "Cycle complete. Start a new focus when ready."
        }
    }
}
