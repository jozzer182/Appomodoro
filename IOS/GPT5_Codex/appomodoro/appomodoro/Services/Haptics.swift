import UIKit

@MainActor
final class Haptics {
    static let shared = Haptics()

    private let notificationGenerator = UINotificationFeedbackGenerator()

    private init() {}

    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(type)
    }
}
