import SwiftUI
import UserNotifications

struct ReminderSettingsView: View {
    @Binding var isPresented: Bool

    // Per-slot state: enabled + time
    @State private var slotEnabled: [String: Bool] = [:]
    @State private var slotTime: [String: Date] = [:]
    // Streak protection
    @State private var streakEnabled: Bool = ReminderManager.isStreakProtectionEnabled
    @State private var streakTime: Date   = ReminderManager.date(for: ReminderManager.streakSlot)
    // Days of week
    @State private var enabledDays: Set<Int> = ReminderManager.enabledDays
    // UI feedback
    @State private var permissionDenied = false
    @State private var errorMessage: String?  = nil

    // Calendar day labels starting Monday
    private let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    // weekday values (Calendar: 1=Sun … 7=Sat) in display order Sun-Sat
    private let weekdays: [Int] = [1, 2, 3, 4, 5, 6, 7]

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Time-slot reminders
                Section {
                    ForEach(ReminderManager.slots) { slot in
                        SlotRow(
                            slot: slot,
                            isOn: Binding(
                                get: { slotEnabled[slot.id] ?? false },
                                set: { slotEnabled[slot.id] = $0; reschedule() }
                            ),
                            time: Binding(
                                get: { slotTime[slot.id] ?? ReminderManager.date(for: slot) },
                                set: {
                                    slotTime[slot.id] = $0
                                    ReminderManager.setDate(slot, to: $0)
                                    reschedule()
                                }
                            )
                        )
                    }
                } header: {
                    Text("Daily reminders")
                } footer: {
                    Text("Enable individual time-block reminders. Each fires at the time you set.")
                }

                // MARK: Days of week
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Remind me on")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 6) {
                            ForEach(weekdays, id: \.self) { day in
                                let isOn = enabledDays.contains(day)
                                Button {
                                    if isOn {
                                        if enabledDays.count > 1 { enabledDays.remove(day) }
                                    } else {
                                        enabledDays.insert(day)
                                    }
                                    ReminderManager.enabledDays = enabledDays
                                    reschedule()
                                } label: {
                                    Text(dayNames[day - 1])
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 6)
                                        .background(isOn ? Color.accentColor : Color(UIColor.systemFill))
                                        .foregroundStyle(isOn ? .white : .primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                } footer: {
                    Text("At least one day must be selected.")
                }

                // MARK: Streak protection
                Section {
                    Toggle(isOn: $streakEnabled) {
                        Label("Streak protection", systemImage: "flame.fill")
                    }
                    .onChange(of: streakEnabled) { _, new in
                        ReminderManager.isStreakProtectionEnabled = new
                        reschedule()
                    }
                    if streakEnabled {
                        DatePicker("Fire at", selection: $streakTime, displayedComponents: .hourAndMinute)
                            .onChange(of: streakTime) { _, new in
                                ReminderManager.setDate(ReminderManager.streakSlot, to: new)
                                reschedule()
                            }
                    }
                } header: {
                    Text("Streak protection")
                } footer: {
                    Text("Sends a reminder each day at the set time so you never break your streak.")
                }

                // MARK: Notifications denied warning
                if permissionDenied {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notifications are off for Vaani.")
                                .fontWeight(.medium)
                            Text("Go to Settings → Notifications → Vaani and enable Allow Notifications.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Button("Open Settings") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                    }
                }

                if let err = errorMessage {
                    Section {
                        Label(err, systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

            }
            .navigationTitle("Reminders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { isPresented = false }
                        .fontWeight(.semibold)
                }
            }
            .onAppear { loadState() }
        }
    }

    // MARK: - Helpers

    private func loadState() {
        for slot in ReminderManager.slots {
            slotEnabled[slot.id] = ReminderManager.isEnabled(slot.id)
            slotTime[slot.id]    = ReminderManager.date(for: slot)
        }
        streakEnabled = ReminderManager.isStreakProtectionEnabled
        streakTime    = ReminderManager.date(for: ReminderManager.streakSlot)
        enabledDays   = ReminderManager.enabledDays
    }

    private func reschedule() {
        // Persist enabled flags
        for slot in ReminderManager.slots {
            ReminderManager.setEnabled(slot.id, slotEnabled[slot.id] ?? false)
        }
        let anyEnabled = slotEnabled.values.contains(true) || streakEnabled
        guard anyEnabled else {
            ReminderManager.scheduleAll { _ in }
            return
        }
        ReminderManager.requestPermissionAndScheduleAll { granted, err in
            permissionDenied = !granted
            errorMessage     = err?.localizedDescription
        }
    }
}

// MARK: - Slot row

private struct SlotRow: View {
    let slot: ReminderSlot
    @Binding var isOn: Bool
    @Binding var time: Date

    var body: some View {
        HStack(spacing: 12) {
            Label(slot.displayName, systemImage: slot.systemImage)
                .fontWeight(.medium)
            Spacer(minLength: 8)
            if isOn {
                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ReminderSettingsView(isPresented: .constant(true))
}
