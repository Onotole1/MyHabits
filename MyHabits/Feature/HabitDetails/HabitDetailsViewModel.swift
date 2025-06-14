//
//  HabitDetailsViewModel.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 14.06.2025.
//
import Foundation

struct HabitDetailsViewModel {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()

    static func make(habit: Habit) -> [Self] {
        let store = HabitsStore.shared

        return store.dates.sorted { $0 > $1 }
            .map {
                let isTracked = store.habit(habit, isTrackedIn: $0)

                let date: String
                switch true {
                case $0.isInToday():
                    date = NSLocalizedString("today", comment: "")
                case $0.isInYesterday():
                    date = NSLocalizedString("yesterday", comment: "")
                case $0.isInDayBeforeYesterday():
                    date = NSLocalizedString("two_days_ago", comment: "")
                default:
                    date = formatter.string(from: $0)
                }

                return HabitDetailsViewModel(
                    date: date,
                    isChecked: isTracked,
                )
            }
    }

    let date: String
    let isChecked: Bool
}
