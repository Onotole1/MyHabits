//
//  HabitDetailsViewCell.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 14.06.2025.
//

import UIKit

class HabitDetailsViewCell: UITableViewCell {

    // MARK: - Subviews

    private lazy var innerView: UIView = {
        UIView()
    }()

    private lazy var dateLabel: UILabel = {
        UILabel()
    }()

    private lazy var checkedLabel: UILabel = {
        let label = UILabel()

        label.setStyledText("✓", with: .body, color: UIColor(named: "AccentColor")!)

        return label
    }()

    // MARK: - Lifecycle

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .subtitle,
            reuseIdentifier: reuseIdentifier
        )

        tuneView()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func tuneView() {
        selectionStyle = .none
    }

    private func addSubviews() {
        contentView.addSubview(innerView)
        [dateLabel, checkedLabel].forEach(innerView.addSubview)
    }

    private func setupConstraints() {
        let commonSpacing = 16.0

        innerView.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        }

        dateLabel.setupConstraints {
            [
                $0.centerYAnchor.constraint(equalTo: innerView.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: commonSpacing),
            ]
        }

        checkedLabel.setupConstraints {
            [
                $0.centerYAnchor.constraint(equalTo: innerView.centerYAnchor),
                $0.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -commonSpacing),
            ]
        }
    }

    // MARK: - Public

    func update(_ model: HabitDetailsViewModel) {
        checkedLabel.isHidden = !model.isChecked
        dateLabel.text = model.date
    }
}
