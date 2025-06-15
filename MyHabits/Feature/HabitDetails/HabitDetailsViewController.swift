//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 14.06.2025.
//

import UIKit

class HabitDetailsViewController: UIViewController {

    // MARK: - Data

    private var data: [HabitDetailsViewModel] = []
    private var habitWithIndex: HabitWithIndex

    // MARK: - Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HabitDetailsViewCell.self)
        tableView.backgroundColor = UIColor(named: "LightGrayColor")!
        return tableView
    }()

    // MARK: - Lifecycle

    init(habitWithIndex: HabitWithIndex) {
        self.habitWithIndex = habitWithIndex
        data = HabitDetailsViewModel.make(habit: habitWithIndex.habit)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupNavigationController()

        tableView.dataSource = self

        view.addSubview(tableView)

        tableView.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                $0.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ]
        }
    }

    // MARK: - Private

    private func setupNavigationController() {
        title = habitWithIndex.habit.name
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("edit_button", comment: ""),
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
    }

    @objc private func editButtonTapped() {
        let habitViewController = HabitViewController(habitWithIndex: habitWithIndex)
        let navController = UINavigationController(rootViewController: habitViewController)
        habitViewController.delegate = self
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension HabitDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        let cell: HabitDetailsViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.update(item)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        NSLocalizedString("habit_details_section", comment: "")
    }
}

// MARK: - HabitDetailsViewControllerDelegate

extension HabitDetailsViewController: HabitViewControllerDelegate {
    func didDeleteHabit() {
        navigationController?.popViewController(animated: true)
    }

    func didUpdateHabit(habit: Habit) {
        title = habit.name
        habitWithIndex = HabitWithIndex(habit: habit, index: habitWithIndex.index)
    }
}
