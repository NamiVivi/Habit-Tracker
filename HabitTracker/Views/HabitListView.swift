import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showingAdd = false
    @State private var habitToDelete: Habit?

    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    ContentUnavailableView {
                        Label("No streaks yet", systemImage: "leaf")
                    } description: {
                        Text("Add something you want to quit and watch the days add up.")
                    } actions: {
                        Button("Add a Habit") { showingAdd = true }
                            .buttonStyle(.borderedProminent)
                    }
                } else {
                    TimelineView(.periodic(from: .now, by: 60)) { timeline in
                        List {
                            ForEach(habits) { habit in
                                NavigationLink(value: habit) {
                                    HabitRow(habit: habit, now: timeline.date)
                                }
                                .swipeActions {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        habitToDelete = habit
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Streaks")
            .navigationDestination(for: Habit.self) { habit in
                HabitDetailView(habit: habit)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Habit", systemImage: "plus") { showingAdd = true }
                }
            }
            .sheet(isPresented: $showingAdd) {
                HabitFormView()
            }
            .alert(
                "Delete \(habitToDelete?.name ?? "habit")?",
                isPresented: Binding(
                    get: { habitToDelete != nil },
                    set: { if !$0 { habitToDelete = nil } }
                )
            ) {
                Button("Delete", role: .destructive) {
                    if let habitToDelete { modelContext.delete(habitToDelete) }
                    habitToDelete = nil
                }
                Button("Cancel", role: .cancel) { habitToDelete = nil }
            } message: {
                Text("This removes the streak, its history and its stickers.")
            }
        }
    }
}

struct HabitRow: View {
    let habit: Habit
    let now: Date

    var body: some View {
        let days = habit.currentDays(at: now)
        HStack(spacing: 14) {
            Text(habit.emoji)
                .font(.system(size: 34))
                .frame(width: 56, height: 56)
                .background(Color.accentColor.opacity(0.15), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                Text("\(days) \(days == 1 ? "day" : "days") free")
                    .font(.title3.bold())
                    .foregroundStyle(Color.accentColor)
                if let next = Milestone.next(afterDays: days) {
                    ProgressView(value: habit.progressToNextMilestone(at: now)) {
                        Text("Next: \(next.sticker) \(next.title)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Every sticker unlocked 🎉")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    HabitListView()
        .modelContainer(for: Habit.self, inMemory: true)
}
