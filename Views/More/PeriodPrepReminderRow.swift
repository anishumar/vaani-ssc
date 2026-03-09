import SwiftUI

struct PeriodPrepReminderRow: View {
    @State private var enabled = PeriodPrepReminderManager.isEnabled
    @State private var daysBefore = PeriodPrepReminderManager.daysBefore

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: $enabled) {
                Label("Remind me before my period", systemImage: "bell.badge")
            }
            .onChange(of: enabled) { _, new in
                PeriodPrepReminderManager.isEnabled = new
                Task { @MainActor in
                    PeriodPrepReminderManager.scheduleIfNeeded(controller: DataController.shared)
                }
            }
            if enabled {
                HStack {
                    Text("\(daysBefore) day\(daysBefore == 1 ? "" : "s") before")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Stepper("", value: $daysBefore, in: 1...7)
                        .labelsHidden()
                        .onChange(of: daysBefore) { _, new in
                            PeriodPrepReminderManager.daysBefore = new
                            Task { @MainActor in
                                PeriodPrepReminderManager.scheduleIfNeeded(controller: DataController.shared)
                            }
                        }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        PeriodPrepReminderRow()
    }
}
