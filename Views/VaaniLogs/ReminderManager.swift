import Foundation
import UserNotifications

// MARK: - Reminder slot definition

struct ReminderSlot: Identifiable {
    let id: String
    let displayName: String
    let systemImage: String
    let defaultHour: Int
    let defaultMinute: Int
    let notificationTitle: String
    let notificationBody: String
}

// MARK: - Manager

enum ReminderManager {

    // MARK: Slots

    static let slots: [ReminderSlot] = [
        ReminderSlot(id: "morning",   displayName: "Morning",   systemImage: "sunrise.fill",
                     defaultHour: 7,  defaultMinute: 0,
                     notificationTitle: "Morning reminder",
                     notificationBody: "Time to check off your morning habits."),
        ReminderSlot(id: "afternoon", displayName: "Afternoon", systemImage: "sun.max.fill",
                     defaultHour: 13, defaultMinute: 0,
                     notificationTitle: "Afternoon check-in",
                     notificationBody: "Don't forget your afternoon tasks."),
        ReminderSlot(id: "evening",   displayName: "Evening",   systemImage: "sunset.fill",
                     defaultHour: 18, defaultMinute: 0,
                     notificationTitle: "Evening reminder",
                     notificationBody: "Time for your evening routine."),
        ReminderSlot(id: "night",     displayName: "Night",     systemImage: "moon.fill",
                     defaultHour: 21, defaultMinute: 0,
                     notificationTitle: "Night reminder",
                     notificationBody: "Finish your night habits before you sleep.")
    ]

    static let streakSlot = ReminderSlot(
        id: "streak", displayName: "Streak protection", systemImage: "flame.fill",
        defaultHour: 21, defaultMinute: 30,
        notificationTitle: "Streak reminder",
        notificationBody: "Complete today's plan before midnight to keep your streak."
    )

    // MARK: UserDefaults keys

    private static func enabledKey(_ id: String)  -> String { "reminder_\(id)_enabled" }
    private static func hourKey(_ id: String)     -> String { "reminder_\(id)_hour" }
    private static func minuteKey(_ id: String)   -> String { "reminder_\(id)_minute" }
    private static func wasSetKey(_ id: String)   -> String { "reminder_\(id)_hourWasSet" }
    private static let daysKey                             = "reminder_days"
    private static let streakProtectionEnabledKey          = "reminder_streak_enabled"

    // MARK: Per-slot access

    static func isEnabled(_ slotId: String) -> Bool {
        UserDefaults.standard.bool(forKey: enabledKey(slotId))
    }
    static func setEnabled(_ slotId: String, _ value: Bool) {
        UserDefaults.standard.set(value, forKey: enabledKey(slotId))
    }

    static func hour(for slotId: String, default defaultHour: Int) -> Int {
        guard UserDefaults.standard.bool(forKey: wasSetKey(slotId)) else { return defaultHour }
        return max(0, min(23, UserDefaults.standard.integer(forKey: hourKey(slotId))))
    }
    static func minute(for slotId: String) -> Int {
        max(0, min(59, UserDefaults.standard.integer(forKey: minuteKey(slotId))))
    }
    static func setTime(_ slotId: String, hour: Int, minute: Int) {
        UserDefaults.standard.set(true,                        forKey: wasSetKey(slotId))
        UserDefaults.standard.set(max(0, min(23, hour)),       forKey: hourKey(slotId))
        UserDefaults.standard.set(max(0, min(59, minute)),     forKey: minuteKey(slotId))
    }

    static func date(for slot: ReminderSlot) -> Date {
        var c = DateComponents()
        c.hour   = hour(for: slot.id, default: slot.defaultHour)
        c.minute = minute(for: slot.id)
        return Calendar.current.date(from: c)
            ?? Calendar.current.date(bySettingHour: slot.defaultHour, minute: slot.defaultMinute, second: 0, of: Date())!
    }
    static func setDate(_ slot: ReminderSlot, to date: Date) {
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        setTime(slot.id, hour: c.hour ?? slot.defaultHour, minute: c.minute ?? 0)
    }

    // MARK: Days of week (1 = Sunday … 7 = Saturday, matching Calendar.weekday)

    static var enabledDays: Set<Int> {
        get {
            let stored = UserDefaults.standard.string(forKey: daysKey) ?? ""
            if stored.isEmpty { return Set(1...7) } // all days by default
            return Set(stored.split(separator: ",").compactMap { Int($0) })
        }
        set {
            let s = newValue.sorted().map(String.init).joined(separator: ",")
            UserDefaults.standard.set(s, forKey: daysKey)
        }
    }

    // MARK: Streak protection

    static var isStreakProtectionEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: streakProtectionEnabledKey) }
        set { UserDefaults.standard.set(newValue, forKey: streakProtectionEnabledKey) }
    }

    // MARK: Scheduling

    /// Schedules (or removes) all enabled slot notifications + streak protection.
    static func scheduleAll(completion: ((Error?) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        let allIds = (slots.map(\.id) + [streakSlot.id]).map { "dailyPlan_\($0)" }
        center.removePendingNotificationRequests(withIdentifiers: allIds)

        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized ||
                  settings.authorizationStatus == .provisional else {
                let err = NSError(
                    domain: "ReminderManager", code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "Notifications are not authorized. Enable them in Settings → Vaani."]
                )
                DispatchQueue.main.async { completion?(err) }
                return
            }

            let days = enabledDays
            var requests: [UNNotificationRequest] = []

            for slot in slots where isEnabled(slot.id) {
                let content       = UNMutableNotificationContent()
                content.title     = slot.notificationTitle
                content.body      = slot.notificationBody
                content.sound     = .default

                let h = hour(for: slot.id, default: slot.defaultHour)
                let m = minute(for: slot.id)

                for day in days {
                    var comp      = DateComponents()
                    comp.hour     = h
                    comp.minute   = m
                    comp.weekday  = day
                    let trigger   = UNCalendarNotificationTrigger(dateMatching: comp, repeats: true)
                    let req       = UNNotificationRequest(
                        identifier: "dailyPlan_\(slot.id)_day\(day)",
                        content: content,
                        trigger: trigger
                    )
                    requests.append(req)
                }
            }

            // Streak protection
            if isStreakProtectionEnabled {
                let content   = UNMutableNotificationContent()
                content.title = streakSlot.notificationTitle
                content.body  = streakSlot.notificationBody
                content.sound = .default
                var comp      = DateComponents()
                comp.hour     = hour(for: streakSlot.id, default: streakSlot.defaultHour)
                comp.minute   = minute(for: streakSlot.id)
                let trigger   = UNCalendarNotificationTrigger(dateMatching: comp, repeats: true)
                let req       = UNNotificationRequest(
                    identifier: "dailyPlan_\(streakSlot.id)",
                    content: content,
                    trigger: trigger
                )
                requests.append(req)
            }

            var lastError: Error?
            let group = DispatchGroup()
            for req in requests {
                group.enter()
                center.add(req) { err in
                    if err != nil { lastError = err }
                    group.leave()
                }
            }
            group.notify(queue: .main) { completion?(lastError) }
        }
    }

    /// Requests permission then schedules all.
    static func requestPermissionAndScheduleAll(completion: @escaping (Bool, Error?) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        scheduleAll { err in completion(true, err) }
                    } else {
                        completion(false, nil)
                    }
                }
            }
    }

    static func getPendingCount(completion: @escaping (Int) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let count = requests.count
            DispatchQueue.main.async { completion(count) }
        }
    }

    // MARK: Legacy shims (used by old code paths)

    static var isReminderEnabled: Bool {
        get { slots.contains { isEnabled($0.id) } || isStreakProtectionEnabled }
        set { } // no-op; individual slots control this now
    }
    static func scheduleReminder(completion: ((Error?) -> Void)? = nil) {
        scheduleAll(completion: completion)
    }
}
