import SwiftUI
import Charts

struct HabitDetailView: View {
    let habit: Habit

    private var lastSevenDays: [DayCompletion] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let completedDays = Set(habit.completions.map { calendar.startOfDay(for: $0) })

        return (0..<7).reversed().map { offset in
            let day = calendar.date(byAdding: .day, value: -offset, to: today)!
            return DayCompletion(day: day, completed: completedDays.contains(day))
        }
    }

    var body: some View {
        List {
            Section("Streak") {
                Text("\(habit.currentStreak) day\(habit.currentStreak == 1 ? "" : "s")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }

            Section("Last 7 days") {
                Chart(lastSevenDays) { entry in
                    BarMark(
                        x: .value("Day", entry.day, unit: .day),
                        y: .value("Done", entry.completed ? 1 : 0)
                    )
                    .foregroundStyle(entry.completed ? .green : .gray.opacity(0.3))
                }
                .frame(height: 160)
                .chartYAxis(.hidden)
            }

            Section {
                Button(habit.isDoneToday ? "Mark not done today" : "Mark done today") {
                    habit.toggleToday()
                }
            }
        }
        .navigationTitle(habit.name)
    }
}

private struct DayCompletion: Identifiable {
    let day: Date
    let completed: Bool
    var id: Date { day }
}
