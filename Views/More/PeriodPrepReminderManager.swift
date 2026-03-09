import Foundation
import UserNotifications

enum PeriodPrepReminderManager {
    private static let enabledKey = "more_periodPrep_enabled"
    private static let daysBeforeKey = "more_periodPrep_daysBefore"
    static let notificationId = "more_periodPrep"

    static var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: enabledKey) }
        set { UserDefaults.standard.set(newValue, forKey: enabledKey) }
    }

    static var daysBefore: Int {
        get {
            let v = UserDefaults.standard.integer(forKey: daysBeforeKey)
            return v > 0 ? v : 3
        }
        set { UserDefaults.standard.set(max(1, min(7, newValue)), forKey: daysBeforeKey) }
    }

    @MainActor
    static func scheduleIfNeeded(controller: DataController) {
        guard isEnabled else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
            return
        }
        guard let predicted = controller.predictedNextPeriodStart() else { return }
        let reminderDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: predicted)!
        if reminderDate <= Date() { return }
        let content = UNMutableNotificationContent()
        content.title = "Period reminder"
        content.body = "Vaani's reminder: your period might be coming soon. Rest and hydration help."
        content.sound = .default
        let comp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
