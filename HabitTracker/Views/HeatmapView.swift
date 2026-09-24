import SwiftUI

/// A GitHub style activity grid: one column per week, one cell per day,
/// filled in when a habit was completed that day.
struct HeatmapView: View {
    let completions: [Date]
    var weeks: Int = 10

    private let cellSize: CGFloat = 10
    private let spacing: CGFloat = 3

    private var days: [[Date]] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let totalDays = weeks * 7

        let allDays = (0..<totalDays).reversed().map { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)!
        }

        return stride(from: 0, to: allDays.count, by: 7).map {
            Array(allDays[$0..<min($0 + 7, allDays.count)])
        }
    }

    private var completedDays: Set<Date> {
        let calendar = Calendar.current
        return Set(completions.map { calendar.startOfDay(for: $0) })
    }

    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ForEach(days.indices, id: \.self) { weekIndex in
                VStack(spacing: spacing) {
                    ForEach(days[weekIndex], id: \.self) { day in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(completedDays.contains(day) ? Color.green : Color.gray.opacity(0.2))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
}

#Preview {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let sample = (0..<40).compactMap { offset -> Date? in
        offset % 3 == 0 ? calendar.date(byAdding: .day, value: -offset, to: today) : nil
    }
    return HeatmapView(completions: sample)
        .padding()
}
