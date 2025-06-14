//
//  HabitDetailsViewModel.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 14.06.2025.
//
import Foundation

struct HabitDetailsViewModel {

    static func make(habit: Habit) -> [Self] {
        let store = HabitsStore.shared

        return store.dates
            .enumerated()
            .map { (index, date) in
                let dateFormatted = store.trackDateString(forIndex: index) ?? ""

                return (date, dateFormatted)
            }
            .sorted { $0.0 > $1.0 }
            .map { (date: Date, dateFormatted: String) in
                let isTracked = store.habit(habit, isTrackedIn: date)

                return HabitDetailsViewModel(
                    date: dateFormatted,
                    isChecked: isTracked,
                )
            }
    }

    let date: String
    let isChecked: Bool
}
