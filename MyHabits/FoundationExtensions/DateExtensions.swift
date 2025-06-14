//
//  DateExtensions.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 14.06.2025.
//

import Foundation

extension Date {
    func isInToday() -> Bool {
        Calendar.current.isDateInToday(self)
    }

    func isInYesterday() -> Bool {
        Calendar.current.isDateInYesterday(self)
    }

    func isInDayBeforeYesterday() -> Bool {
        let today = Date()

        guard let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today) else {
            return false
        }

        return Calendar.current.isDate(self, inSameDayAs: dayBeforeYesterday)
    }
}
