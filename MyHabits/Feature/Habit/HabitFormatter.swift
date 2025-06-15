//
//  HabitFormatter.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 15.06.2025.
//

import UIKit

struct HabitFormatter {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static func formatSelectedDate(_ date: Date) -> NSAttributedString {
        let formatString = NSLocalizedString("create_habit_screen_time_text", comment: "")
        let dateFormatted = formatter.string(from: date)
        let fullString = String(format: formatString, dateFormatted)

        let attributedString = NSMutableAttributedString(string: fullString)
        let accentColor = UIColor(named: "AccentColor")!
        let dateRange = (fullString as NSString).range(of: dateFormatted)
        attributedString.addAttribute(.foregroundColor, value: accentColor, range: dateRange)

        return attributedString
    }
}
