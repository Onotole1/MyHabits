//
//  HabitDetailsViewControllerDelegate.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 15.06.2025.
//

protocol HabitViewControllerDelegate: AnyObject {
    func didDeleteHabit()
    func didUpdateHabit(habit: Habit)
}
