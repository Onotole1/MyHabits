//
//  InfoHeaderViewCell.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 09.06.2025.
//

import UIKit

class InfoHeaderViewCell: UITableViewCell {

    // MARK: - Subviews

    private lazy var headerLabel: UILabel = {
        let label = UILabel()

        label.setStyledText(NSLocalizedString("info_screen_header", comment: ""), with: .title3)

        return label
    }()

    // MARK: - Lifecycle

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .subtitle,
            reuseIdentifier: reuseIdentifier,
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
        contentView.addSubview(headerLabel)
    }

    private func setupConstraints() {
        headerLabel.setupConstraints {
            let commonInset: CGFloat = 16
            return [
                $0.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: commonInset),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -commonInset),
                $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -commonInset),
            ]
        }
    }
}
