import SwiftUI

struct MoreView: View {
    @AppStorage("currentStoryIndex") private var currentStoryIndex: Int = -1
    @State private var showReminderSettings = false
    @State private var showEditProfile = false
    @State private var showAbout = false
    @State private var showOneMinuteReset = false
    private let dc = DataController.shared

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 24) {
                        journeyItem(
                            value: "\(dc.getCurrentStreak())",
                            label: "day streak"
                        )
                        journeyItem(
                            value: "\(dc.getCompletedDaysInLastSevenDays())/7",
                            label: "days this week"
                        )
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Your journey")
                }

                Section {
                    MythBusterCardView()
                } header: {
                    Text("Myth buster of the day")
                }

                Section {
                    NavigationLink { ProgressGardenView() } label: {
                        Label("Progress garden", systemImage: "leaf.fill")
                    }
                    NavigationLink { BadgesGridView() } label: {
                        Label("Badges", systemImage: "star.fill")
                    }
                } header: {
                    Text("Your progress")
                }

                Section {
                    Button {
                        showOneMinuteReset = true
                    } label: {
                        Label("One-minute reset", systemImage: "wind")
                    }
                    .foregroundStyle(.primary)
                } header: {
                    Text("Wellness")
                }

                Section {
                    NavigationLink { PeriodTrackerView() } label: {
                        Label("Period tracker", systemImage: "calendar")
                    }
                } header: {
                    Text("Cycle")
                }

                Section {
                    NavigationLink { ConditionListView() } label: {
                        Label("Conditions & health", systemImage: "heart.text.square.fill")
                    }
                } header: {
                    Text("Health")
                }

                Section {
                    Button {
                        showReminderSettings = true
                    } label: {
                        Label("Reminders", systemImage: "bell.badge")
                    }
                    .foregroundStyle(.primary)
                    Button {
                        showEditProfile = true
                    } label: {
                        Label("Edit profile", systemImage: "person.crop.circle")
                    }
                    .foregroundStyle(.primary)
                    Button {
                        showAbout = true
                    } label: {
                        Label("About Vaani", systemImage: "info.circle")
                    }
                    .foregroundStyle(.primary)
                } header: {
                    Text("Settings")
                }
            }
            .navigationTitle("Vaani's Corner")
            .sheet(isPresented: $showReminderSettings) {
                ReminderSettingsView(isPresented: $showReminderSettings)
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(isPresented: $showEditProfile)
            }
            .sheet(isPresented: $showAbout) {
                AboutVaaniView(isPresented: $showAbout)
            }
            .fullScreenCover(isPresented: $showOneMinuteReset) {
                OneMinuteResetView(isPresented: $showOneMinuteReset)
            }
        }
    }

    private func journeyItem(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MoreView()
}
