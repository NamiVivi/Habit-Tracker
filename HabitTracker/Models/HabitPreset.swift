import Foundation

struct HabitPreset: Identifiable {
    let name: String
    let emoji: String
    var id: String { name }

    static let all: [HabitPreset] = [
        HabitPreset(name: "Smoking", emoji: "🚬"),
        HabitPreset(name: "Vaping", emoji: "💨"),
        HabitPreset(name: "Drinking", emoji: "🍺"),
        HabitPreset(name: "Sugar", emoji: "🍬"),
        HabitPreset(name: "Caffeine", emoji: "☕️"),
        HabitPreset(name: "Social Media", emoji: "📱"),
        HabitPreset(name: "Fast Food", emoji: "🍔"),
        HabitPreset(name: "Gambling", emoji: "🎰"),
    ]

    static let emojiChoices: [String] = [
        "🚭", "🚬", "💨", "🍺", "🍷", "🥃", "🍬", "🍩",
        "☕️", "🥤", "📱", "🎮", "🍔", "🎰", "🛒", "💅",
    ]
}
