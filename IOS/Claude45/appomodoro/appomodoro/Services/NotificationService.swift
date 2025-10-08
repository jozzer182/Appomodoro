//
//  NotificationService.swift
//  appomodoro
//
//  Created by JOSE ZARABANDA on 10/8/25.
//

import UserNotifications
import Foundation

/// Service for managing local notifications
@MainActor
class NotificationService: NSObject {
    static let shared = NotificationService()
    
    private override init() {
        super.init()
    }
    
    /// Request notification permission from user
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Failed to request notification authorization: \(error)")
            return false
        }
    }
    
    /// Schedule a notification for phase completion
    func schedulePhaseNotification(phase: PomodoroPhase, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Appomodoro"
        content.body = "\(phase.description) complete!"
        content.sound = .default
        content.categoryIdentifier = "POMODORO_PHASE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: "pomodoro_phase_\(UUID().uuidString)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    /// Cancel all pending notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Cancel specific notification
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
