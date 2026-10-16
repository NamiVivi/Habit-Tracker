import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var celebrations: [Celebration] = []

    var body: some View {
        TabView {
            HabitListView()
                .tabItem { Label("Streaks", systemImage: "flame") }
            StickerBookView()
                .tabItem { Label("Stickers", systemImage: "star.square.on.square") }
        }
        .sheet(item: activeCelebration) { celebration in
            CelebrationView(celebration: celebration)
        }
        // Re-check milestones and notifications whenever habits change.
        .task(id: notificationItems) {
            checkMilestones()
            await NotificationScheduler.reschedule(notificationItems)
        }
        // Keep checking while the app is open so milestones pop up live.
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(30))
                checkMilestones()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { checkMilestones() }
        }
    }

    private var notificationItems: [NotificationScheduler.Item] {
        habits.map { .init(name: $0.name, emoji: $0.emoji, startDate: $0.startDate) }
    }

    /// Shows queued celebrations one at a time.
    private var activeCelebration: Binding<Celebration?> {
        Binding(
            get: { celebrations.first },
            set: { newValue in
                if newValue == nil, !celebrations.isEmpty {
                    celebrations.removeFirst()
                }
            }
        )
    }

    private func checkMilestones() {
        let now = Date.now
        for habit in habits {
            let new = habit.collectNewMilestones(at: now)
            if !new.isEmpty {
                celebrations.append(Celebration(habitName: habit.name, habitEmoji: habit.emoji, milestones: new))
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
