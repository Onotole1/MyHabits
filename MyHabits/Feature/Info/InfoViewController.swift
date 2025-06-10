//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 07.06.2025.
//

import UIKit

class InfoViewController: UIViewController {
    private let data = [InfoViewModel.header] + InfoStore.getInfoParagraphs().map(InfoViewModel.paragraph)

    private lazy var tableFooterView: UIView = {
        UIView(frame: .zero)
    }()

    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("info_screen_title", comment: "")
        view.backgroundColor = .systemBackground

        addSubviews()
        setupConstraints()
        tuneTableView()
    }

    // MARK: - Private

    private func tuneTableView() {
        tableView.tableFooterView = tableFooterView
        tableView.separatorStyle = .none

        tableView.register(InfoParagraphViewCell.self)
        tableView.register(InfoHeaderViewCell.self)

        tableView.dataSource = self
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.setupConstraints {
            [
                $0.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ]
        }
    }
}

// MARK: - UITableViewDataSource

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        switch item {
        case .header:
            return tableView.dequeueReusableCell(for: indexPath) as InfoHeaderViewCell
        case .paragraph(let paragraph):
            let cell: InfoParagraphViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(paragraph)
            return cell
        }
    }
}
