import SwiftUI

struct PeriodTrackerView: View {
    private let dc = DataController.shared
    @State private var entries: [PeriodEntry] = []
    @State private var showLogSheet = false

    var body: some View {
        List {
            if let next = dc.predictedNextPeriodStart() {
                Section {
                    HStack {
                        Label("Predicted next period", systemImage: "calendar.badge.clock")
                        Spacer()
                        Text(next, style: .date)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Section {
                PeriodPrepReminderRow()
            } header: {
                Text("Reminders")
            }
            Section {
                ForEach(entries) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.startDate, style: .date)
                                .font(.subheadline.weight(.medium))
                            if let end = entry.endDate {
                                Text("– \(end, style: .date)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        if let flow = entry.flow {
                            Text(flow)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Button {
                    showLogSheet = true
                } label: {
                    Label("Log period", systemImage: "plus.circle.fill")
                }
            } header: {
                Text("History")
            }
        }
        .navigationTitle("Period tracker")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            entries = dc.getPeriodEntries()
        }
        .sheet(isPresented: $showLogSheet) {
            LogPeriodView(isPresented: $showLogSheet) {
                entries = dc.getPeriodEntries()
            }
        }
    }
}

private struct LogPeriodView: View {
    @Binding var isPresented: Bool
    var onSave: () -> Void
    @State private var startDate = Date()
    @State private var flow: String = "medium"
    private let flows = ["light", "medium", "heavy"]

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                Picker("Flow", selection: $flow) {
                    ForEach(flows, id: \.self) { Text($0).tag($0) }
                }
            }
            .navigationTitle("Log period")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        DataController.shared.addPeriodEntry(startDate: startDate, flow: flow)
                        onSave()
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PeriodTrackerView()
    }
}
