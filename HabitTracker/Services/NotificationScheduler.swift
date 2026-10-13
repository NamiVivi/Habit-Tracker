import Foundation
import UserNotifications

/// Schedules local notifications for each habit's upcoming milestones.
enum NotificationScheduler {
    struct Item: Hashable, Sendable {
        let name: String
        let emoji: String
        let startDate: Date
    }

    /// How many upcoming milestones to schedule per habit.
    private static let upcomingPerHabit = 3

    static func reschedule(_ items: [Item]) async {
        let center = UNUserNotificationCenter.current()
        guard !items.isEmpty else {
            center.removeAllPendingNotificationRequests()
            return
        }
        let granted = (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        guard granted else { return }

        center.removeAllPendingNotificationRequests()
        let now = Date.now
        for item in items {
            let elapsedDays = Int(max(0, now.timeIntervalSince(item.startDate)) / 86_400)
            let upcoming = Milestone.all.filter { $0.days > elapsedDays }.prefix(upcomingPerHabit)
            for milestone in upcoming {
                let fireDate = item.startDate.addingTimeInterval(TimeInterval(milestone.days) * 86_400)
                let interval = fireDate.timeIntervalSince(now)
                guard interval > 0 else { continue }

                let content = UNMutableNotificationContent()
                content.title = "\(milestone.sticker) \(milestone.title) free from \(item.name)!"
                content.body = "\(milestone.message) Open the app to collect your sticker."
                content.sound = .default

                let request = UNNotificationRequest(
                    identifier: "\(item.name)-\(item.startDate.timeIntervalSince1970)-\(milestone.days)",
                    content: content,
                    trigger: UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
                )
                try? await center.add(request)
            }
        }
    }
}
