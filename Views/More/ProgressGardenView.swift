import SwiftUI

struct ProgressGardenView: View {
    @State private var info = DataController.shared.progressGardenInfo()
    @State private var animateProgress = false

    private let stageColors: [Color] = [
        Color(hex: "#A0856C"),
        Color(hex: "#8B6914"),
        Color(hex: "#4CAF50"),
        Color(hex: "#2E7D32"),
        Color(hex: "#1B5E20")
    ]

    private let tips: [[String]] = [
        ["Complete your first plan checklist today.", "Opening the app daily plants your first seed."],
        ["Keep a 3-day streak to help your sprout grow.", "Complete 2 plan days this week."],
        ["Reach a 5-day streak to grow a full plant.", "Complete 5 plan days this week."],
        ["You're almost there! Hit a 7-day streak.", "Complete all 7 days this week to bloom."],
        ["Your garden is in full bloom!", "Keep your streak going to stay flourishing."]
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                stageImageSection
                stageBadge
                statsRow
                progressSection
                tipsSection
                nextStageSection
                howItWorksSection
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Progress Garden")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            info = DataController.shared.progressGardenInfo()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.8)) {
                    animateProgress = true
                }
            }
        }
    }

    // MARK: - Stage Image

    private var stageImageSection: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [stageColors[info.stage].opacity(0.25), Color.clear],
                        center: .center,
                        startRadius: 20,
                        endRadius: 140
                    )
                )
                .frame(width: 280, height: 280)

            if UIImage(named: "Garden_Stage\(info.stage)") != nil {
                Image("Garden_Stage\(info.stage)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
                    .id(info.stage)
            } else {
                placeholderPlant
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
                    .id(info.stage)
            }
        }
        .padding(.top, 12)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: info.stage)
    }

    private var placeholderPlant: some View {
        let icons = ["circle.dotted", "leaf", "leaf.fill", "camera.macro", "tree.fill"]
        return Image(systemName: icons[min(info.stage, icons.count - 1)])
            .font(.system(size: 100))
            .foregroundStyle(stageColors[info.stage])
    }

    // MARK: - Stage Badge

    private var stageBadge: some View {
        Text(info.stageName)
            .font(.title2.weight(.semibold))
            .foregroundStyle(stageColors[info.stage])
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(stageColors[info.stage].opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(
                value: "\(info.streak)",
                label: "day streak",
                icon: "flame.fill",
                color: .orange
            )
            statCard(
                value: "\(info.completedDays)/7",
                label: "days this week",
                icon: "checkmark.circle.fill",
                color: .green
            )
        }
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2.weight(.semibold))
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    // MARK: - Progress Section

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Progress to next stage")
                    .font(.subheadline.weight(.medium))
                Spacer()
                if info.isMaxStage {
                    Text("Max reached")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(info.daysToNextStage) day\(info.daysToNextStage == 1 ? "" : "s") away")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(UIColor.systemFill))
                        .frame(height: 10)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [stageColors[info.stage].opacity(0.7), stageColors[info.stage]],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: animateProgress ? geo.size.width * info.progressFraction : 0,
                            height: 10
                        )
                }
            }
            .frame(height: 10)

            // Stage milestone dots
            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { i in
                    Circle()
                        .fill(i <= info.stage ? stageColors[min(i, stageColors.count - 1)] : Color(UIColor.systemFill))
                        .frame(width: 10, height: 10)
                    if i < 4 { Spacer() }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    // MARK: - Tips Section

    private var tipsSection: some View {
        let currentTips = tips[min(info.stage, tips.count - 1)]
        return VStack(alignment: .leading, spacing: 12) {
            Text("How to grow your garden")
                .font(.subheadline.weight(.medium))
            ForEach(currentTips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "leaf.fill")
                        .font(.caption)
                        .foregroundStyle(stageColors[info.stage])
                        .padding(.top, 3)
                    Text(tip)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    // MARK: - Next Stage Section

    private var nextStageSection: some View {
        let stageNames   = ["Bare Soil", "Seed", "Sprout", "Plant", "Blooming Tree"]
        let stageIcons   = ["circle.dotted", "leaf", "leaf.fill", "camera.macro", "tree.fill"]
        let streakNeeded = [0, 1, 3, 5, 7]
        let daysNeeded   = [0, 1, 2, 5, 7]

        return VStack(alignment: .leading, spacing: 14) {
            Text("Your journey")
                .font(.subheadline.weight(.medium))

            ForEach(0..<5, id: \.self) { i in
                let isReached  = i <= info.stage
                let isCurrent  = i == info.stage
                let isNext     = i == info.stage + 1

                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(isReached ? stageColors[i].opacity(0.15) : Color(UIColor.systemFill))
                            .frame(width: 40, height: 40)
                        Image(systemName: stageIcons[i])
                            .font(.system(size: 18))
                            .foregroundStyle(isReached ? stageColors[i] : Color.secondary.opacity(0.4))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(stageNames[i])
                                .font(.subheadline.weight(isCurrent ? .semibold : .regular))
                                .foregroundStyle(isReached ? .primary : .secondary)
                            if isCurrent {
                                Text("YOU ARE HERE")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(stageColors[i])
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(stageColors[i].opacity(0.15))
                                    .clipShape(Capsule())
                            }
                        }
                        if i == 0 {
                            Text("Starting point")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("\(streakNeeded[i])-day streak  or  \(daysNeeded[i]) days/week")
                                .font(.caption)
                                .foregroundStyle(isNext ? stageColors[i] : .secondary)
                        }
                    }

                    Spacer()

                    if isReached {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(stageColors[i])
                    } else if isNext {
                        Image(systemName: "lock.open")
                            .foregroundStyle(stageColors[i].opacity(0.6))
                    } else {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(Color.secondary.opacity(0.3))
                    }
                }

                if i < 4 {
                    Rectangle()
                        .fill(Color(UIColor.separator).opacity(0.4))
                        .frame(width: 1, height: 12)
                        .padding(.leading, 19)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    // MARK: - How It Works Section

    private var howItWorksSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("How your garden grows")
                .font(.subheadline.weight(.medium))

            infoRow(
                icon: "checkmark.square.fill",
                color: .green,
                title: "Complete your daily plan",
                body: "Tick off your health checklist in the Plans tab each day. Every completed day waters your garden."
            )
            infoRow(
                icon: "flame.fill",
                color: .orange,
                title: "Build a streak",
                body: "Complete the plan on consecutive days to build a streak. A longer streak unlocks higher stages faster."
            )
            infoRow(
                icon: "calendar.badge.checkmark",
                color: .indigo,
                title: "Consistency over perfection",
                body: "Missing a day resets your streak, but your completed days this week still count. Both paths grow your garden."
            )
            infoRow(
                icon: "info.circle.fill",
                color: .secondary,
                title: "Stages are calculated fresh",
                body: "Every time you open this screen, your stage is recalculated based on your latest streak and weekly activity."
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private func infoRow(icon: String, color: Color, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(color)
                .frame(width: 22)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(body)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProgressGardenView()
    }
}
