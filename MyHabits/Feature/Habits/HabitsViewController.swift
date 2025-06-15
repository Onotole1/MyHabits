//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 07.06.2025.
//

import UIKit

class HabitsViewController: UIViewController {

    // MARK: - Constants

    private typealias HabitIndex = Int
    private enum Section: Int, CaseIterable {
        case progress
        case habits
    }
    private static let habitsVerticalSpacing: CGFloat = 12

    // MARK: - Properties

    private let habitsStore = HabitsStore.shared
    private var progressItems: [HabitsViewModel] = []
    private var habitItems: [HabitsViewModel] = []

    private lazy var checkBoxClickListener: (Habit, HabitIndex) -> Void = {
        { [weak self] habit, index in
            guard let self else { return }
            self.habitsStore.track(habit)

            refreshData()

            let indexPath = IndexPath(item: index, section: Section.habits.rawValue)

            collectionView.reloadItems(at: [indexPath])

            let progressIndexPath = IndexPath(item: 0, section: 0)
            progressItems[0] = HabitsViewModel.progress(habitsStore.todayProgress)
            collectionView.reloadItems(at: [progressIndexPath])
        }
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitCollectionViewCell.self)
        collectionView.register(ProgressCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "LightGrayColor")!

        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        view.addSubview(collectionView)
        collectionView.delegate = self

        setupConstraints()
    }

    private func setupNavigationBar() {
        title = NSLocalizedString("habits_screen_title", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped)
        )
    }

    private func setupConstraints() {
        collectionView.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        refreshData()
        collectionView.reloadData()
    }

    // MARK: - Actions

    private func refreshData() {
        progressItems = [HabitsViewModel.progress(habitsStore.todayProgress)]
        habitItems = habitsStore.habits.enumerated().map { (index, habit) in
            HabitsViewModel.habit(HabitUIModel.from(
                domainModel: habit,
                rootClickListener: { [weak self] in
                    self?.navigationController?.pushViewController(
                        HabitDetailsViewController(habitWithIndex: HabitWithIndex(habit: habit, index: index)),
                        animated: true,
                    )
                },
                checkBoxClickListener: { [weak self] in
                    self?.checkBoxClickListener(habit, index)
                }
            ))
        }
    }

    @objc private func addButtonTapped() {
        let navController = UINavigationController(rootViewController: HabitViewController())
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == Section.progress.rawValue ? progressItems.count : habitItems.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = indexPath.section == Section.progress.rawValue
            ? progressItems[indexPath.item]
            : habitItems[indexPath.item]

        switch item {
        case .habit(let uiModel):
            let cell: HabitCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.update(uiModel)
            return cell
        case .progress(let progress):
            let cell: ProgressCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.progress = progress
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let section = Section(rawValue: section) else {
            return .zero
        }

        switch section {
        case .progress:
            return .init(top: 22, left: 0, bottom: 6, right: 0)
        case .habits:
            return .init(top: Self.habitsVerticalSpacing, left: 0, bottom: 0, right: 0)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return section == Section.progress.rawValue ? 0 : Self.habitsVerticalSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        if section == Section.habits.rawValue && !habitItems.isEmpty {
            return CGSize(width: collectionView.bounds.width, height: Self.habitsVerticalSpacing)
        }
        return .zero
    }
}
