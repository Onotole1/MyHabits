//
//  HabitViewBuilder.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 15.06.2025.
//

import UIKit

struct HabitViewBuilder {
    static func createNameTextField() -> UITextField {
        let textField = UITextField()

        textField.setDSTextStyle(.headline)
        textField.setStyledPlaceholder(
            NSLocalizedString("create_habit_screen_name_hint", comment: ""),
            with: .body, color: .systemGray2,
        )

        return textField
    }

    static func createColorView(selectedColor: UIColor, target: Any?, action: Selector) -> UIView {
        let view = UIView()
        view.backgroundColor = selectedColor
        view.layer.cornerRadius = 15
        let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }

    static func createHabitColorLabel() -> UILabel {
        let label = UILabel()

        label.setStyledText(NSLocalizedString("create_habit_screen_color_header", comment: ""), with: .footNote)

        return label
    }

    static func createHabitNameLabel() -> UILabel {
        let label = UILabel()

        label.setStyledText(NSLocalizedString("create_habit_screen_name_header", comment: ""), with: .footNote)

        return label
    }

    static func createHabitTimeLabel() -> UILabel {
        let label = UILabel()

        label.setStyledText(NSLocalizedString("create_habit_screen_time_header", comment: ""), with: .footNote)

        return label
    }

    static func createHabitTimeText(formatSelectedDate: () -> NSAttributedString) -> UILabel {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.attributedText = formatSelectedDate()

        return label
    }

    static func createHabitTimePicker(selectedDate: Date, target: Any?, action: Selector) -> UIDatePicker {
        let picker = UIDatePicker()

        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.date = selectedDate
        picker.addTarget(target, action: action, for: .valueChanged)

        return picker
    }

    static func createDeleteButton(isEditing: Bool, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)

        button.setStyledTitle(
            NSLocalizedString("create_habit_delete_button", comment: ""),
            with: .body,
            color: UIColor(named: "RedColor")!,
        )
        button.addTarget(target, action: action, for: .touchUpInside)
        button.isHidden = !isEditing

        return button
    }

    static func createColorPicker(
        selectedColor: UIColor,
        sourceView: UIView,
        colorPickerDelegate: UIColorPickerViewControllerDelegate?,
        popoverDelegate: UIPopoverPresentationControllerDelegate?,
    ) -> UIColorPickerViewController {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = NSLocalizedString("create_habit_screen_color_picker_title", comment: "")
        colorPicker.supportsAlpha = false
        colorPicker.delegate = colorPickerDelegate
        colorPicker.selectedColor = selectedColor
        colorPicker.modalPresentationStyle = .popover

        if let popoverController = colorPicker.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.permittedArrowDirections = [.up, .down]
            popoverController.delegate = popoverDelegate
        }

        return colorPicker
    }
}
