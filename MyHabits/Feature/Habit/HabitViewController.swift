//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 10.06.2025.
//

import UIKit

class HabitViewController: UIViewController {

    // MARK: - Constants

    private static let commonSpacing = 16.0

    // MARK: - Delegate

    weak var delegate: HabitViewControllerDelegate?

    // MARK: - State

    private var editedHabitIndex: HabitWithIndex?
    private var editedHabit: Habit? {
        editedHabitIndex?.habit
    }

    private var selectedColor: UIColor

    private var selectedDate: Date {
        didSet {
            habitTimeText.attributedText = formatSelectedDate()
        }
    }

    // MARK: - Subviews

    private lazy var habitNameTextField: UITextField = {
        HabitViewBuilder.createNameTextField()
    }()

    private lazy var habitNameLabel: UILabel = {
        HabitViewBuilder.createHabitNameLabel()
    }()

    private lazy var habitColorLabel: UILabel = {
        HabitViewBuilder.createHabitColorLabel()
    }()

    private lazy var habitColorView: UIView = {
        HabitViewBuilder.createColorView(selectedColor: selectedColor, target: self, action: #selector(chooseColor))
    }()

    private lazy var habitTimeLabel: UILabel = {
        HabitViewBuilder.createHabitTimeLabel()
    }()

    private lazy var habitTimeText: UILabel = {
        HabitViewBuilder.createHabitTimeText(
            formatSelectedDate: formatSelectedDate,
        )
    }()

    private lazy var timePicker: UIDatePicker = {
        HabitViewBuilder.createHabitTimePicker(selectedDate: selectedDate, target: self, action: #selector(dateChanged))
    }()

    private lazy var deleteButton: UIButton = {
        HabitViewBuilder.createDeleteButton(isEditing: isEditing, target: self, action: #selector(deleteHabit))
    }()

    // MARK: - Lifecycle

    init(habitWithIndex: HabitWithIndex? = nil) {
        self.editedHabitIndex = habitWithIndex
        let habit = habitWithIndex?.habit
        self.selectedColor = habit?.color ?? UIColor.random
        self.selectedDate = habit?.date ?? Date()

        super.init(nibName: nil, bundle: nil)

        if let habitName = habit?.name {
            self.habitNameTextField.text = habitName
        }
        isEditing = habit != nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        hideKeyboardOnTapOutside()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        setupHabitNameLabelConstraints()
        setupHabitNameTextFieldConstraints()
        setupHabitColorLabelConstraints()
        setupHabitColorViewConstraints()
        setupHabitColorViewConstraints()
        setupHabitTimeLabelConstraints()
        setupHabitTimeTextConstraints()
        setupTimePickerConstraints()
        setupDeleteButtonConstraints()
    }

    private func setupDeleteButtonConstraints() {
        deleteButton.setupConstraints {
            [
                $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
                $0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ]
        }
    }

    private func setupTimePickerConstraints() {
        timePicker.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitTimeText.bottomAnchor, constant: 15),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ]
        }
    }

    private func setupHabitTimeTextConstraints() {
        habitTimeText.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitTimeLabel.bottomAnchor, constant: 7),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.commonSpacing),
            ]
        }
    }

    private func setupHabitTimeLabelConstraints() {
        habitTimeLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitColorView.bottomAnchor, constant: 15),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.commonSpacing),
            ]
        }
    }

    private func setupHabitColorViewConstraints() {
        habitColorView.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitColorLabel.bottomAnchor, constant: 7),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.commonSpacing),
                $0.widthAnchor.constraint(equalToConstant: 30),
                $0.heightAnchor.constraint(equalToConstant: 30),
            ]
        }
    }

    private func setupHabitColorLabelConstraints() {
        habitColorLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 15),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.commonSpacing),
            ]
        }
    }

    private func setupHabitNameTextFieldConstraints() {
        habitNameTextField.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 7),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.commonSpacing),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.commonSpacing),
            ]
        }
    }

    private func setupHabitNameLabelConstraints() {
        habitNameLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.commonSpacing),
            ]
        }
    }

    // MARK: - Listeners

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func deleteHabit() {
        guard let habitWithIndex = editedHabitIndex else { return }
        let alert = UIAlertController(
            title: NSLocalizedString("delete_habit_title", comment: ""),
            message: String(
                format: NSLocalizedString("delete_habit_text", comment: ""),
                arguments: [habitWithIndex.habit.name],
            ),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("cancel_button", comment: ""),
            style: .default,
            handler: nil
        ))

        alert.addAction(UIAlertAction(
            title: NSLocalizedString("delete_button", comment: ""),
            style: .destructive,
            handler: { [weak self] _ in
                let store = HabitsStore.shared
                store.habits.remove(at: habitWithIndex.index)
                self?.delegate?.didDeleteHabit()
                self?.dismiss(animated: true, completion: nil)
            }
        ))

        self.present(alert, animated: true, completion: nil)
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
            self.present(alert, animated: true, completion: nil)
            return
        }

        let newHabit = Habit(
            name: habitName,
            date: selectedDate,
            color: selectedColor,
        )
        let store = HabitsStore.shared

        if isEditing {
            store.habits[editedHabitIndex!.index] = newHabit
            self.delegate?.didUpdateHabit(habit: newHabit)
        } else {
            store.habits.append(newHabit)
        }

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

    // MARK: - Private

    private func hideKeyboardOnTapOutside() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func setupNavigationBar() {
        title = isEditing ? NSLocalizedString("create_habit_screen_edit", comment: "")
            : NSLocalizedString("create_habit_screen_save", comment: "")

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
            deleteButton,
        ].forEach(view.addSubview)
    }

    private func formatSelectedDate() -> NSAttributedString {
        HabitFormatter.formatSelectedDate(selectedDate)
    }
}

// MARK: - UIColorPickerViewControllerDelegate

extension HabitViewController: UIColorPickerViewControllerDelegate {
    public func colorPickerViewControllerDidFinish(_ colorPicker: UIColorPickerViewController) {
        selectedColor = colorPicker.selectedColor
        habitColorView.backgroundColor = selectedColor
    }
}
