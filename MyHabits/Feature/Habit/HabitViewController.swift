//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 10.06.2025.
//

import UIKit

class HabitViewController: UIViewController {

    private let formatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    private var selectedColor = UIColor.random

    var selectedDate = Date() {
        didSet {
            habitTimeText.attributedText = formatSelectedDate()
        }
    }

    private lazy var habitNameTextField: UITextField = {
        let textField = UITextField()

        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("create_habit_screen_name_hint", comment: ""),
            attributes: [.foregroundColor: UIColor.systemGray2]
        )

        return textField
    }()

    private lazy var habitNameLabel: UILabel = {
        let label = UILabel()

        label.setStyledText(NSLocalizedString("create_habit_screen_name_header", comment: ""), with: .footNote)

        return label
    }()

    private lazy var habitColorLabel: UILabel = {
        let label = UILabel()

        label.setStyledText(NSLocalizedString("create_habit_screen_color_header", comment: ""), with: .footNote)

        return label
    }()

    private lazy var habitColorView: UIView = {
        let view = UIView()

        view.backgroundColor = selectedColor
        view.layer.cornerRadius = 15

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseColor))
        view.addGestureRecognizer(gestureRecognizer)

        return view
    }()

    private lazy var habitTimeLabel: UILabel = {
        let label = UILabel()

        label.setStyledText(NSLocalizedString("create_habit_screen_time_header", comment: ""), with: .footNote)

        return label
    }()

    private lazy var habitTimeText: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.attributedText = formatSelectedDate()

        return label
    }()

    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()

        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.date = selectedDate
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        return picker
    }()

    private func formatSelectedDate() -> NSAttributedString {
        let formatString = NSLocalizedString("create_habit_screen_time_text", comment: "")
        let dateFormatted = formatter.string(from: selectedDate)
        let fullString = String(format: formatString, dateFormatted)

        let attributedString = NSMutableAttributedString(string: fullString)

        let accentColor: UIColor = UIColor(named: "AccentColor")!

        let dateRange = (fullString as NSString).range(of: dateFormatted)

        attributedString.addAttribute(.foregroundColor, value: accentColor, range: dateRange)

        return attributedString
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupNavigationBar()
        addSubviews()
        setupConstraints()
    }

    private func setupConstraints() {
        let commonSpacing = 16.0
        habitNameLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: commonSpacing),
            ]
        }

        habitNameTextField.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 7),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: commonSpacing),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -commonSpacing),
            ]
        }

        habitColorLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 15),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: commonSpacing),
            ]
        }

        habitColorView.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitColorLabel.bottomAnchor, constant: 7),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: commonSpacing),
                $0.widthAnchor.constraint(equalToConstant: 30),
                $0.heightAnchor.constraint(equalToConstant: 30),
            ]
        }

        habitTimeLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitColorView.bottomAnchor, constant: 15),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: commonSpacing),
            ]
        }

        habitTimeText.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitTimeLabel.bottomAnchor, constant: 7),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: commonSpacing),
            ]
        }

        timePicker.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitTimeText.bottomAnchor, constant: 15),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ]
        }
    }

    private func setupNavigationBar() {
        title = NSLocalizedString("create_habit_screen_save", comment: "")

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("create_habit_screen_cancel", comment: ""),
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("create_habit_screen_save", comment: ""),
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }

    private func addSubviews() {
        [
            habitNameLabel,
            habitNameTextField,
            habitColorLabel,
            habitColorView,
            timePicker,
            habitTimeLabel,
            habitTimeText,
        ].forEach(view.addSubview)
    }

    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func saveButtonTapped() {
        guard let habitName = habitNameTextField.text, !habitName.isEmpty else {
            let alert = UIAlertController(
                title: NSLocalizedString("create_habit_screen_error_title", comment: ""),
                message: NSLocalizedString("create_habit_screen_error_message", comment: ""),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: NSLocalizedString("ok_button", comment: ""),
                style: .default,
                handler: nil
            ))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }

        let newHabit = Habit(
            name: habitName,
            date: selectedDate,
            color: selectedColor,
        )
        let store = HabitsStore.shared
        store.habits.append(newHabit)

        self.dismiss(animated: true, completion: nil)
    }

    @objc private func dateChanged() {
        self.selectedDate = timePicker.date
    }

    @objc private func chooseColor() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = NSLocalizedString("create_habit_screen_color_picker_title", comment: "")
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        colorPicker.selectedColor = selectedColor
        colorPicker.modalPresentationStyle = .popover
        self.present(colorPicker, animated: true)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    public func colorPickerViewControllerDidFinish(_ colorPicker: UIColorPickerViewController) {
        selectedColor = colorPicker.selectedColor
        habitColorView.backgroundColor = selectedColor
    }
}
