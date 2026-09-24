import Testing
import Foundation
@testable import HabitTracker

struct HabitTests {
    @Test func toggleTodayAddsThenRemovesCompletion() {
        let habit = Habit(name: "Read")
        #expect(habit.isDoneToday == false)

        habit.toggleToday()
        #expect(habit.isDoneToday == true)

        habit.toggleToday()
        #expect(habit.isDoneToday == false)
    }

    @Test func streakCountsConsecutiveDaysEndingToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let completions = (0..<3).map { calendar.date(byAdding: .day, value: -$0, to: today)! }
        let habit = Habit(name: "Exercise", completions: completions)

        #expect(habit.currentStreak == 3)
    }

    @Test func streakStaysAliveIfYesterdayDoneButNotYetToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let dayBefore = calendar.date(byAdding: .day, value: -2, to: today)!
        let habit = Habit(name: "Meditate", completions: [yesterday, dayBefore])

        #expect(habit.currentStreak == 2)
    }

    @Test func streakBreaksOnGap() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!
        let habit = Habit(name: "Journal", completions: [threeDaysAgo])

        #expect(habit.currentStreak == 0)
    }
}
