import Foundation
import SwiftData

@Observable
final class HabitListViewModel {
    var newHabitName: String = ""

    func addHabit(to context: ModelContext) {
        let trimmed = newHabitName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        context.insert(Habit(name: trimmed))
        newHabitName = ""
    }
}
