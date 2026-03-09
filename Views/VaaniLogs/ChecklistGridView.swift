import SwiftUI

/// 2×2 grid of selected disease checklists with mood check-in, monthly calendar,
/// pending-tasks badge, and a daily note at the bottom.
struct ChecklistGridView: View {
    let enabledIndices: [Int]
    var onEdit: () -> Void
    var onReorder: (([Int]) -> Void)? = nil
    var onRemind: (() -> Void)? = nil
    @ObservedObject private var dataController = DataController.shared
    @State private var selectedCheckListId: ChecklistNavigationId?
    @State private var localOrder: [Int] = []
    @State private var noteText: String = ""
    @State private var selectedMood: Int? = nil
    @State private var showWeekInsights = false
    @State private var showMonthInsights = false
    @State private var quickSheetPresented = false
    @State private var quickCategory: ChecklistCategory = .morning
    @State private var quickCheckListIndex = 0
    @State private var quickCheckList: CheckList = DataController.shared.getCheckList(at: 0)
    @State private var didApplyRestDayToday = false

    private let singleColumn = [
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                moodCheckInSection
                streakBanner
                upNextActionSection
                if showWeekInsights {
                    weeklySummaryBanner
                    progressChartSection
                }
                if showMonthInsights {
                    monthlyCalendarSection
                }

                // Disease cards: all 1x1 (full width)
                LazyVGrid(columns: singleColumn, spacing: 16) {
                    ForEach(localOrder, id: \.self) { diseaseCard(for: $0) }
                }

                todayNoteSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            localOrder   = enabledIndices
            noteText     = dataController.getNote(for: Date())
            selectedMood = dataController.getMood(for: Date())
            didApplyRestDayToday = isRestDayAppliedToday()
        }
        .onChange(of: enabledIndices) { _, new in localOrder = new }
        .navigationTitle("Plans")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    onEdit()
                } label: {
                    Label("Edit", systemImage: "slider.horizontal.3")
                }
            }
            if onRemind != nil {
                ToolbarItem(placement: .secondaryAction) {
                    Button {
                        onRemind?()
                    } label: {
                        Label("Reminders", systemImage: "bell.badge")
                    }
                }
            }
        }
        .navigationDestination(item: $selectedCheckListId) { id in
            RoutineDetailView(checkListIndex: id.index)
        }
        .sheet(isPresented: $quickSheetPresented, onDismiss: {
            quickCheckList = dataController.getCheckList(at: quickCheckListIndex)
            if quickCheckList.progress >= 100 {
                dataController.recordPlanCompletionDate()
            }
        }) {
            CheckBoxListItemView(
                selectedTimeOfDay: $quickCategory,
                checkList: $quickCheckList,
                isSheetPresented: $quickSheetPresented,
                checkListIndex: quickCheckListIndex
            )
        }
    }

    // MARK: - Disease card builder

    @ViewBuilder
    private func diseaseCard(for listIndex: Int) -> some View {
        let list = dataController.getCheckList(at: listIndex)
        DiseaseCard(
            name: list.name,
            iconImageName: diseaseIconName(for: list.name),
            progress: list.progress,
            isComplete: list.progress >= 100,
            pendingBadge: pendingBadge(for: list)
        ) {
            selectedCheckListId = ChecklistNavigationId(index: listIndex)
        }
        .draggable(String(listIndex))
        .dropDestination(for: String.self) { dropped, _ in
            guard let s = dropped.first, let dragged = Int(s) else { return false }
            return handleReorder(dragged: dragged, onto: listIndex)
        }
    }

    private func diseaseIconName(for name: String) -> String? {
        switch name {
        case "PCOS": return "PCOS"
        case "PCOD": return "PCOD"
        case "Endometriosis": return "Endometriosis"
        case "Thyroid": return "Thyroid"
        case "Anemia": return "Anemia"
        case "PMS / PMDD": return "PMS_PMDD"
        case "Irregular periods": return "IrregularPeriods"
        case "UTI prevention": return "UTIPrevention"
        case "General wellness": return "GeneralWellness"
        default: return nil
        }
    }

    private func pendingBadge(for list: CheckList) -> String {
        let all = list.morningList + list.afternoonList + list.eveningList + list.nightList
        let pending = all.filter { !$0.isChecked }.count
        return pending == 0 ? "All done" : "\(pending) pending"
    }

    private var currentTimeCategory: ChecklistCategory {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return .morning
        case 12..<17: return .afternoon
        case 17..<21: return .evening
        default: return .night
        }
    }

    private func pendingCount(for list: CheckList, in category: ChecklistCategory) -> Int {
        list.getItems(for: category).filter { !$0.isChecked }.count
    }

    private var upNextTarget: (index: Int, name: String, pending: Int, category: ChecklistCategory)? {
        guard !localOrder.isEmpty else { return nil }
        let category = currentTimeCategory
        for idx in localOrder {
            let list = dataController.getCheckList(at: idx)
            let pending = pendingCount(for: list, in: category)
            if pending > 0 {
                return (idx, list.name, pending, category)
            }
        }
        if let first = localOrder.first {
            let list = dataController.getCheckList(at: first)
            return (first, list.name, 0, category)
        }
        return nil
    }

    @ViewBuilder
    private var upNextActionSection: some View {
        if let target = upNextTarget {
            Button {
                quickCheckListIndex = target.index
                quickCategory = target.category
                quickCheckList = dataController.getCheckList(at: target.index)
                quickSheetPresented = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(Color.accentColor)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Up next")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(target.pending > 0
                             ? "\(target.name): \(target.pending) \(target.category.rawValue.lowercased()) tasks pending"
                             : "\(target.name): \(target.category.rawValue) is done. Review anytime.")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer(minLength: 4)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Reorder

    private func handleReorder(dragged: Int, onto target: Int) -> Bool {
        guard dragged != target,
              let from = localOrder.firstIndex(of: dragged),
              let to   = localOrder.firstIndex(of: target) else { return false }
        var next = localOrder
        next.remove(at: from)
        next.insert(dragged, at: to)
        localOrder = next
        onReorder?(localOrder)
        return true
    }

    // MARK: - Mood check-in

    private let moods: [(emoji: String, label: String)] = [
        ("😔", "Low"),
        ("😐", "Okay"),
        ("🙂", "Good"),
        ("😊", "Great"),
        ("🥰", "Amazing")
    ]

    @ViewBuilder
    private var moodCheckInSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How are you feeling today?")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            HStack(spacing: 0) {
                ForEach(Array(moods.enumerated()), id: \.offset) { idx, mood in
                    let isSelected = selectedMood == idx + 1
                    Button {
                        selectedMood = idx + 1
                        dataController.setMood(for: Date(), mood: idx + 1)
                    } label: {
                        VStack(spacing: 4) {
                            Text(mood.emoji)
                                .font(.title2)
                            Text(mood.label)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(isSelected ? Color.accentColor : .secondary)
                        }
                        .padding(.vertical, 8)
                        .frame(minHeight: 44)
                        .frame(maxWidth: .infinity)
                        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .animation(.easeInOut(duration: 0.15), value: selectedMood)
                    .accessibilityLabel("Mood \(mood.label)")
                }
            }

            // Contextual message card that appears when a mood is selected
            if let mood = selectedMood, let response = moodResponse(for: mood) {
                HStack(alignment: .top, spacing: 10) {
                    Text(response.icon)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(response.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(response.color)
                        Text(response.message)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(response.color.opacity(0.1))
                .cornerRadius(8)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.25), value: selectedMood)
            }

            if selectedMood == 1 {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "heart.text.square.fill")
                        .foregroundStyle(Color(hex: "#7B61B0"))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Need a rest day?")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text("You can protect today's streak without forcing every task.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 6)
                    Button(didApplyRestDayToday ? "Applied" : "Protect streak") {
                        applyRestDayForToday()
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(didApplyRestDayToday ? Color.gray.opacity(0.25) : Color.accentColor)
                    .foregroundStyle(didApplyRestDayToday ? Color.primary : Color.white)
                    .clipShape(Capsule())
                    .disabled(didApplyRestDayToday)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
                .transition(.opacity)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
        .animation(.easeInOut(duration: 0.25), value: selectedMood)
    }

    private struct MoodResponse {
        let icon: String
        let title: String
        let message: String
        let color: Color
    }

    private func moodResponse(for mood: Int) -> MoodResponse? {
        switch mood {
        case 1:
            return MoodResponse(
                icon: "💜",
                title: "Be gentle with yourself today.",
                message: "Hard days happen. Try just one small task — even drinking a glass of water counts. Your body is doing its best.",
                color: Color(hex: "#7B61B0")
            )
        case 2:
            return MoodResponse(
                icon: "🌿",
                title: "An okay day is still a day forward.",
                message: "You don't have to feel amazing to show up for yourself. Pick one routine block and start there.",
                color: Color(hex: "#4A8C6A")
            )
        case 3:
            return MoodResponse(
                icon: "🌸",
                title: "A good day — make the most of it!",
                message: "Your energy is there. This is a great time to tick off your morning or evening habits.",
                color: Color(hex: "#C2607A")
            )
        case 4:
            return MoodResponse(
                icon: "✨",
                title: "You're doing really well!",
                message: "Your consistency is making a real difference. Keep the streak alive — you've got this.",
                color: Color(hex: "#E8911A")
            )
        case 5:
            return MoodResponse(
                icon: "🔥",
                title: "Incredible energy today!",
                message: "Channel this into your full routine — mark everything done and keep that streak burning!",
                color: Color(hex: "#D94F3D")
            )
        default:
            return nil
        }
    }

    private func moodAccentColor(_ mood: Int) -> Color {
        switch mood {
        case 1: return Color(hex: "#7B61B0")
        case 2: return Color(hex: "#4A8C6A")
        case 3: return Color(hex: "#C2607A")
        case 4: return Color(hex: "#E8911A")
        case 5: return Color(hex: "#D94F3D")
        default: return Color.primary.opacity(0.75)
        }
    }

    private func restDayKey(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = .current
        return "restDay_\(f.string(from: date))"
    }

    private func isRestDayAppliedToday() -> Bool {
        UserDefaults.standard.bool(forKey: restDayKey(for: Date()))
    }

    private func applyRestDayForToday() {
        dataController.recordPlanCompletionDate()
        UserDefaults.standard.set(true, forKey: restDayKey(for: Date()))
        didApplyRestDayToday = true
    }

    // MARK: - Monthly calendar

    @ViewBuilder
    private var monthlyCalendarSection: some View {
        let completedDates = Set(dataController.getPlanCompletionDateStrings())
        let cal = Calendar.current
        let today = Date()
        let monthStart = cal.date(from: cal.dateComponents([.year, .month], from: today))!
        let totalDays  = cal.range(of: .day, in: .month, for: today)!.count
        let firstWeekday = cal.firstWeekday
        let startWeekday = (cal.component(.weekday, from: monthStart) - firstWeekday + 7) % 7
        let todayDay = cal.component(.day, from: today)
        let fmt: DateFormatter = {
            let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f
        }()
        let weekdaySymbols = cal.shortWeekdaySymbols

        VStack(alignment: .leading, spacing: 8) {
            Text(today.formatted(.dateTime.month(.wide).year()))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            // Day-of-week headers (respects device locale: Sun-Sat or Mon-Sun)
            HStack(spacing: 4) {
                ForEach(0..<7, id: \.self) { i in
                    let idx = (i + firstWeekday - 1) % 7
                    Text(String(weekdaySymbols[idx].prefix(1)))
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                // Empty offset cells
                ForEach(0..<startWeekday, id: \.self) { _ in
                    Color.clear.frame(height: 26)
                }
                // Day cells
                ForEach(1...totalDays, id: \.self) { day in
                    let date = cal.date(byAdding: .day, value: day - 1, to: monthStart)!
                    let dateStr = fmt.string(from: date)
                    let isDone   = completedDates.contains(dateStr)
                    let isToday  = day == todayDay
                    let isFuture = day > todayDay
                    let mood = dataController.getMood(for: date)
                    let moodColor = mood.map(moodAccentColor) ?? Color.primary.opacity(0.75)
                    let moodEmoji: String? = {
                        guard let idx = mood, idx >= 1, idx <= moods.count else { return nil }
                        return moods[idx - 1].emoji
                    }()

                    ZStack {
                        Circle()
                            .fill(
                                isDone   ? moodColor :
                                isToday  ? Color.accentColor.opacity(0.25) :
                                Color.clear
                            )
                        if isToday && !isDone {
                            Circle()
                                .strokeBorder(Color.primary.opacity(0.35), lineWidth: 1)
                        }
                        Text("\(day)")
                            .font(.caption2)
                            .foregroundStyle(
                                isDone   ? Color.white :
                                isFuture ? Color.secondary.opacity(0.5) :
                                Color.primary
                            )
                        if isDone, let emoji = moodEmoji {
                            Text(emoji)
                                .font(.caption2)
                                .offset(y: 9)
                        }
                    }
                    .frame(height: 26)
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }

    // MARK: - Stats banners

    @ViewBuilder
    private var streakBanner: some View {
        let streak = dataController.getCurrentStreak()
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                Text("\(streak)-day streak")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
            Spacer(minLength: 8)
            insightToggleButton(
                title: "Week",
                systemImage: "chart.bar.fill",
                isOn: showWeekInsights
            ) {
                showWeekInsights.toggle()
            }
            insightToggleButton(
                title: "Month",
                systemImage: "calendar",
                isOn: showMonthInsights
            ) {
                showMonthInsights.toggle()
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }

    @ViewBuilder
    private func insightToggleButton(
        title: String,
        systemImage: String,
        isOn: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: systemImage)
                Text(title)
            }
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .foregroundStyle(isOn ? .white : .primary)
            .background(isOn ? Color.accentColor : Color(.tertiarySystemFill))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var weeklySummaryBanner: some View {
        let completed = dataController.getCompletedDaysInLastSevenDays()
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .foregroundStyle(.secondary)
            Text("This week: \(completed)/7 days completed")
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.accentColor.opacity(0.15))
        .cornerRadius(10)
    }

    @ViewBuilder
    private var progressChartSection: some View {
        let days = dataController.getLastSevenDaysCompletion()
        VStack(alignment: .leading, spacing: 8) {
            Text("Last 7 days")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
            HStack(spacing: 6) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, item in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.completed ? Color.accentColor : Color(.tertiarySystemFill))
                            .frame(height: 32)
                        Text(item.dayLabel)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }

    // MARK: - Note

    @ViewBuilder
    private var todayNoteSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's note")
                .font(.headline)
                .foregroundStyle(.primary)
            ZStack(alignment: .topLeading) {
                if noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Write a quick note for today...")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 10)
                }
                TextEditor(text: $noteText)
                    .scrollContentBackground(.hidden)
                    .accessibilityLabel("Today's note")
            }
            .frame(minHeight: 80)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .onChange(of: noteText) { _, _ in
                dataController.setNote(for: Date(), text: noteText)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

// MARK: - Supporting types

private struct ChecklistNavigationId: Identifiable, Hashable {
    let index: Int
    var id: Int { index }
}

// MARK: - Disease card

struct DiseaseCard: View {
    let name: String
    var iconImageName: String? = nil
    let progress: Double
    let isComplete: Bool
    var pendingBadge: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                // Left: title + pending under it, then progress
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    if let badge = pendingBadge {
                        Text(badge)
                            .font(.caption)
                            .foregroundStyle(badge.contains("done") ? .green : .secondary)
                    }
                    Spacer(minLength: 4)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(Int(progress))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(isComplete ? .green : .secondary)
                        ProgressView(value: progress, total: 100)
                            .tint(isComplete ? .green : Color.accentColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right: icon uses full space (no background)
                if let icon = iconImageName {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(14)
            .frame(height: 130)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isComplete ? Color.green.opacity(0.15) : Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ChecklistGridView(enabledIndices: [0, 1, 2, 3], onEdit: {})
    }
}
