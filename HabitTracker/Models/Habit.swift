import Foundation
import SwiftData

@Model
final class Habit {
    var name: String
    var createdAt: Date
    var completions: [Date]

    init(name: String, createdAt: Date = Date(), completions: [Date] = []) {
        self.name = name
        self.createdAt = createdAt
        self.completions = completions
    }

    var isDoneToday: Bool {
        completions.contains { Calendar.current.isDateInToday($0) }
    }

    func toggleToday() {
        let calendar = Calendar.current
        if let index = completions.firstIndex(where: { calendar.isDateInToday($0) }) {
            completions.remove(at: index)
        } else {
            completions.append(Date())
        }
    }

    /// Counts consecutive days ending today (or yesterday, if today isn't done yet)
    /// so a streak doesn't reset to zero the moment the clock passes midnight.
    var currentStreak: Int {
        let calendar = Calendar.current
        let days = Set(completions.map { calendar.startOfDay(for: $0) })
        guard !days.isEmpty else { return 0 }

        var streak = 0
        var cursor = calendar.startOfDay(for: Date())

        if !days.contains(cursor) {
            cursor = calendar.date(byAdding: .day, value: -1, to: cursor)!
            guard days.contains(cursor) else { return 0 }
        }

        while days.contains(cursor) {
            streak += 1
            cursor = calendar.date(byAdding: .day, value: -1, to: cursor)!
        }

        return streak
    }
}
