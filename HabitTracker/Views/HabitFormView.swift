import SwiftUI
import SwiftData

/// Adds a new habit, or edits an existing one when `habit` is set.
struct HabitFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let habit: Habit?
    @State private var name: String
    @State private var emoji: String
    @State private var startDate: Date

    init(habit: Habit? = nil) {
        self.habit = habit
        _name = State(initialValue: habit?.name ?? "")
        _emoji = State(initialValue: habit?.emoji ?? "🚭")
        _startDate = State(initialValue: habit?.startDate ?? .now)
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                if habit == nil {
                    Section("Quick start") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(HabitPreset.all) { preset in
                                    Button {
                                        name = preset.name
                                        emoji = preset.emoji
                                    } label: {
                                        Text("\(preset.emoji) \(preset.name)")
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.accentColor.opacity(name == preset.name ? 0.3 : 0.12), in: Capsule())
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                    }
                }

                Section("What are you quitting?") {
                    TextField("e.g. Smoking", text: $name)
                        .textInputAutocapitalization(.words)
                }

                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 8) {
                        ForEach(HabitPreset.emojiChoices, id: \.self) { choice in
                            Text(choice)
                                .font(.title)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle().fill(choice == emoji ? Color.accentColor.opacity(0.3) : .clear)
                                )
                                .onTapGesture { emoji = choice }
                                .accessibilityAddTraits(choice == emoji ? [.isButton, .isSelected] : .isButton)
                        }
                    }
                }

                Section {
                    DatePicker("Last time", selection: $startDate, in: ...Date.now)
                } footer: {
                    Text("Your streak counts up from this moment. Set it in the past if you've already stopped.")
                }
            }
            .navigationTitle(habit == nil ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(trimmedName.isEmpty)
                }
            }
        }
    }

    private func save() {
        if let habit {
            habit.name = trimmedName
            habit.emoji = emoji
            if habit.startDate != startDate {
                habit.updateStartDate(startDate)
            }
        } else {
            modelContext.insert(Habit(name: trimmedName, emoji: emoji, startDate: startDate))
        }
        dismiss()
    }
}

#Preview {
    HabitFormView()
        .modelContainer(for: Habit.self, inMemory: true)
}
