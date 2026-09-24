import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var viewModel = HabitListViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("New habit", text: $viewModel.newHabitName)
                            .onSubmit { viewModel.addHabit(to: context) }
                        Button {
                            viewModel.addHabit(to: context)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(viewModel.newHabitName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                ForEach(habits) { habit in
                    NavigationLink {
                        HabitDetailView(habit: habit)
                    } label: {
                        HabitRow(habit: habit)
                    }
                }
                .onDelete(perform: deleteHabits)
            }
            .navigationTitle("Habits")
            .toolbar { EditButton() }
        }
    }

    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            context.delete(habits[index])
        }
    }
}

private struct HabitRow: View {
    let habit: Habit

    var body: some View {
        HStack {
            Button {
                habit.toggleToday()
            } label: {
                Image(systemName: habit.isDoneToday ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.isDoneToday ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading) {
                Text(habit.name)
                Text("\(habit.currentStreak) day streak")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
