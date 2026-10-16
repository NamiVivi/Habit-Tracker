import Foundation

/// A reward that unlocks once a streak reaches a number of days.
struct Milestone: Identifiable, Hashable {
    let days: Int
    let title: String
    let sticker: String
    let message: String

    var id: Int { days }

    static let all: [Milestone] = [
        Milestone(days: 1, title: "1 Day", sticker: "🌱",
                  message: "The first day is the hardest, and you did it."),
        Milestone(days: 3, title: "3 Days", sticker: "🍀",
                  message: "Three days in. The cravings start to loosen their grip."),
        Milestone(days: 7, title: "1 Week", sticker: "⭐️",
                  message: "A full week! You're building real momentum."),
        Milestone(days: 15, title: "15 Days", sticker: "🏅",
                  message: "Over two weeks strong. This is becoming your new normal."),
        Milestone(days: 30, title: "1 Month", sticker: "🌙",
                  message: "A whole month. Take a moment to be proud of yourself."),
        Milestone(days: 60, title: "2 Months", sticker: "🔥",
                  message: "Two months on fire. Keep it burning."),
        Milestone(days: 90, title: "3 Months", sticker: "💎",
                  message: "Ninety days. That's a habit of its own now."),
        Milestone(days: 180, title: "6 Months", sticker: "🚀",
                  message: "Half a year! Look how far you've come."),
        Milestone(days: 270, title: "9 Months", sticker: "🌈",
                  message: "Nine months of choosing yourself."),
        Milestone(days: 365, title: "1 Year", sticker: "👑",
                  message: "One full year. You are royalty."),
        Milestone(days: 730, title: "2 Years", sticker: "🏆",
                  message: "Two years. A true champion."),
        Milestone(days: 1825, title: "5 Years", sticker: "🦄",
                  message: "Five years. Legendary."),
    ]

    static func reached(byDays days: Int) -> [Milestone] {
        all.filter { $0.days <= days }
    }

    static func next(afterDays days: Int) -> Milestone? {
        all.first { $0.days > days }
    }

    static func latest(forDays days: Int) -> Milestone? {
        all.last { $0.days <= days }
    }
}
