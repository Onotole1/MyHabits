//
//  InfoParagraphViewCell.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 08.06.2025.
//

import UIKit

class InfoParagraphViewCell: UITableViewCell {

    // MARK: - Subviews

    private lazy var paragraphLabel: UILabel = {
        let label = UILabel()

        label.numberOfLines = 0

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

    // MARK: - Public

    func update(_ text: String) {
        paragraphLabel.setStyledText(text, with: .body)
    }

    // MARK: - Private

    private func tuneView() {
        selectionStyle = .none
    }

    private func addSubviews() {
        contentView.addSubview(paragraphLabel)
    }

    private func setupConstraints() {
        paragraphLabel.setupConstraints {
            let horizontalInset: CGFloat = 16
            return [
                $0.topAnchor.constraint(equalTo: contentView.topAnchor),
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalInset),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalInset),
                $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            ]
        }
    }
}
