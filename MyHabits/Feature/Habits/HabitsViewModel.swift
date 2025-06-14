//
//  HabitsViewModel.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 11.06.2025.
//
import UIKit

enum HabitsViewModel {
    case habit(HabitUIModel)

    case progress(Float)
}

struct HabitUIModel {
    let name: String
    let dateString: String
    let isAlreadyTakenToday: Bool
    let color: UIColor
    let counter: Int
    let rootClickListener: () -> Void
    let checkBoxClickListener: () -> Void

    static func from(
        domainModel: Habit,
        rootClickListener: @escaping () -> Void,
        checkBoxClickListener: @escaping () -> Void,
    ) -> Self {
        .init(
            name: domainModel.name,
            dateString: domainModel.dateString,
            isAlreadyTakenToday: domainModel.isAlreadyTakenToday,
            color: domainModel.color,
            counter: domainModel.trackDates.count,
            rootClickListener: rootClickListener,
            checkBoxClickListener: checkBoxClickListener,
        )
    }
}
