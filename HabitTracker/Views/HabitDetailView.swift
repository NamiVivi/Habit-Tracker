import SwiftUI
import SwiftData

struct HabitDetailView: View {
    let habit: Habit
    @State private var showingEdit = false
    @State private var confirmingReset = false
    @State private var resetCount = 0

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { timeline in
            let now = timeline.date
            let days = habit.currentDays(at: now)

            ScrollView {
                VStack(spacing: 28) {
                    ZStack {
                        ProgressRing(progress: habit.progressToNextMilestone(at: now))
                            .frame(width: 220, height: 220)
                        VStack(spacing: 2) {
                            Text(habit.emoji).font(.system(size: 44))
                            Text("\(days)")
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .contentTransition(.numericText())
                            Text(days == 1 ? "day free" : "days free")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    VStack(spacing: 6) {
                        Text(Self.breakdown(habit.elapsed(at: now)))
                            .font(.title3.monospacedDigit())
                        if let next = Milestone.next(afterDays: days) {
                            Text("Next sticker: \(next.sticker) \(next.title)")
                                .foregroundStyle(.secondary)
                        }
                        Text("Since \(habit.startDate.formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 12) {
                        StatTile(value: "\(habit.bestStreakDays(at: now))", label: "Best streak")
                        StatTile(value: "\(habit.resetDates.count)", label: "Resets")
                        StatTile(value: "\(habit.earnedMilestoneDays.count)/\(Milestone.all.count)", label: "Stickers")
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("This streak")
                            .font(.headline)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 84), spacing: 12)], spacing: 16) {
                            ForEach(Milestone.all) { milestone in
                                StickerView(milestone: milestone, isEarned: days >= milestone.days)
                            }
                        }
                    }

                    Button(role: .destructive) {
                        confirmingReset = true
                    } label: {
                        Label("I slipped up. Reset streak", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .padding()
            }
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") { showingEdit = true }
        }
        .sheet(isPresented: $showingEdit) {
            HabitFormView(habit: habit)
        }
        .confirmationDialog("Reset your \(habit.name) streak?", isPresented: $confirmingReset, titleVisibility: .visible) {
            Button("Reset Streak", role: .destructive) {
                withAnimation { habit.reset() }
                resetCount += 1
            }
        } message: {
            Text("It's okay, slip-ups are part of quitting. Your best streak and collected stickers are kept.")
        }
        .sensoryFeedback(.warning, trigger: resetCount)
    }

    static func breakdown(_ interval: TimeInterval) -> String {
        let total = Int(interval)
        let days = total / 86_400
        let hours = (total % 86_400) / 3_600
        let minutes = (total % 3_600) / 60
        let seconds = total % 60
        return "\(days)d \(hours)h \(minutes)m \(seconds)s"
    }
}

struct ProgressRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.accentColor.opacity(0.15), lineWidth: 18)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(colors: [.teal, .accentColor, .green], center: .center),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
        }
    }
}

struct StatTile: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold().monospacedDigit())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    let container = try! ModelContainer(for: Habit.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let habit = Habit(name: "Smoking", emoji: "🚬", startDate: .now.addingTimeInterval(-9 * 86_400))
    container.mainContext.insert(habit)
    return NavigationStack { HabitDetailView(habit: habit) }
        .modelContainer(container)
}
