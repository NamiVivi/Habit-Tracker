import SwiftUI
import SwiftData

struct StickerBookView: View {
    @Query(sort: \Habit.createdAt) private var habits: [Habit]

    private var collectedCount: Int {
        habits.reduce(0) { $0 + $1.earnedMilestoneDays.count }
    }

    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    ContentUnavailableView(
                        "Your sticker book is empty",
                        systemImage: "star.square.on.square",
                        description: Text("Add a habit to start earning stickers at 1 day, 1 week, 1 month and beyond.")
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("\(collectedCount) of \(habits.count * Milestone.all.count) stickers collected")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            ForEach(habits) { habit in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("\(habit.emoji) \(habit.name)")
                                        .font(.headline)
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 84), spacing: 12)], spacing: 16) {
                                        ForEach(Milestone.all) { milestone in
                                            StickerView(
                                                milestone: milestone,
                                                isEarned: habit.earnedMilestoneDays.contains(milestone.days)
                                            )
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18))
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Sticker Book")
        }
    }
}

#Preview {
    StickerBookView()
        .modelContainer(for: Habit.self, inMemory: true)
}
