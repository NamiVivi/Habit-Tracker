import Foundation
import SwiftData

/// Something the user is trying to quit. The streak counts up from `startDate`.
@Model
final class Habit {
    var name: String = ""
    var emoji: String = "🚭"
    /// The last time the user did the habit; the streak counts from here.
    var startDate: Date = Date.now
    var createdAt: Date = Date.now
    /// Longest streak (in days) from previous attempts.
    var longestPastStreakDays: Int = 0
    /// Every time the user logged a slip-up.
    var resetDates: [Date] = []
    /// Stickers collected for good, kept even after a reset.
    var earnedMilestoneDays: [Int] = []
    /// Milestones already celebrated during the current streak.
    var celebratedMilestoneDays: [Int] = []

    init(name: String, emoji: String, startDate: Date = .now) {
        self.name = name
        self.emoji = emoji
        self.startDate = startDate
        self.createdAt = .now
    }

    static var secondsPerDay: TimeInterval { 86_400 }

    /// Seconds since the last slip-up.
    func elapsed(at now: Date = .now) -> TimeInterval {
        max(0, now.timeIntervalSince(startDate))
    }

    /// Whole days (24-hour periods) since the last slip-up.
    func currentDays(at now: Date = .now) -> Int {
        Int(elapsed(at: now) / Self.secondsPerDay)
    }

    func bestStreakDays(at now: Date = .now) -> Int {
        max(longestPastStreakDays, currentDays(at: now))
    }

    /// Progress from the most recent milestone to the next one, 0...1.
    func progressToNextMilestone(at now: Date = .now) -> Double {
        let days = currentDays(at: now)
        guard let next = Milestone.next(afterDays: days) else { return 1 }
        let previousDays = Double(Milestone.latest(forDays: days)?.days ?? 0)
        let span = (Double(next.days) - previousDays) * Self.secondsPerDay
        let done = elapsed(at: now) - previousDays * Self.secondsPerDay
        return min(1, max(0, done / span))
    }

    /// Records milestones reached in the current streak that haven't been
    /// celebrated yet, adds their stickers to the collection, and returns them.
    func collectNewMilestones(at now: Date = .now) -> [Milestone] {
        let new = Milestone.reached(byDays: currentDays(at: now))
            .filter { !celebratedMilestoneDays.contains($0.days) }
        guard !new.isEmpty else { return [] }
        celebratedMilestoneDays.append(contentsOf: new.map(\.days))
        for milestone in new where !earnedMilestoneDays.contains(milestone.days) {
            earnedMilestoneDays.append(milestone.days)
        }
        return new
    }

    /// The user slipped up: start a fresh streak but keep stats and stickers.
    func reset(at now: Date = .now) {
        longestPastStreakDays = bestStreakDays(at: now)
        resetDates.append(now)
        startDate = now
        celebratedMilestoneDays = []
    }

    /// Changes the start date and forgets celebrations that no longer apply,
    /// so they can be celebrated again if the streak reaches them.
    func updateStartDate(_ date: Date) {
        startDate = date
        let days = currentDays()
        celebratedMilestoneDays.removeAll { $0 > days }
    }
}
