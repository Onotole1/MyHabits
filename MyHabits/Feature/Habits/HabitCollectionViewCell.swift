//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 11.06.2025.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {

    // MARK: - Subviews

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.numberOfLines = 0

        return label
    }()

    private lazy var dateLabel: UILabel = {
        UILabel()
    }()

    private lazy var counterLabel: UILabel = {
        UILabel()
    }()

    private lazy var innerView: UIView = {
        UIView()
    }()

    private lazy var isAlreadyTakenTodayCheckbox: CustomCheckbox = {
        CustomCheckbox()
    }()

    private var rootClickListener: (() -> Void)?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        tuneView()
        addSubviews()
        setupConstraints()
        setupListeners()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isAlreadyTakenTodayCheckbox.checkedChangeListener = nil
        nameLabel.text = nil
        dateLabel.text = nil
        counterLabel.text = nil
        rootClickListener = nil
        isAlreadyTakenTodayCheckbox.setChecked(false)
    }

    // MARK: - Update

    func update(_ viewModel: HabitUIModel) {
        nameLabel.setStyledText(viewModel.name, with: .headline, color: viewModel.color)
        isAlreadyTakenTodayCheckbox.setChecked(viewModel.isAlreadyTakenToday)
        isAlreadyTakenTodayCheckbox.checkboxTintColor = viewModel.color
        isAlreadyTakenTodayCheckbox.checkedChangeListener = { _ in
            viewModel.checkBoxClickListener()
        }
        dateLabel.setStyledText(viewModel.dateString, with: .caption)
        counterLabel.setStyledText(
            String(format: NSLocalizedString("habits_screen_item_count", comment: ""), viewModel.counter),
            with: .footNoteCell,
        )
        rootClickListener = viewModel.rootClickListener
    }

    // MARK: - Private

    private func setupListeners() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rootTapped))
        innerView.addGestureRecognizer(tapGesture)
        innerView.isUserInteractionEnabled = true
    }

    @objc private func rootTapped() {
        rootClickListener?()
    }

    private func tuneView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
    }

    private func addSubviews() {
        contentView.addSubview(innerView)
        [nameLabel, dateLabel, counterLabel, isAlreadyTakenTodayCheckbox].forEach(innerView.addSubview)
    }

    private func setupConstraints() {
        let commonOffset = 20.0

        innerView.setupConstraints {
            [
                $0.heightAnchor.constraint(greaterThanOrEqualToConstant: 130),
                $0.topAnchor.constraint(equalTo: contentView.topAnchor),
                $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ]
        }

        nameLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: innerView.topAnchor, constant: commonOffset),
                $0.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: commonOffset),
                $0.trailingAnchor.constraint(
                    lessThanOrEqualTo: isAlreadyTakenTodayCheckbox.leadingAnchor,
                    constant: -8,
                ),
            ]
        }

        dateLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
                $0.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: commonOffset),
                $0.trailingAnchor.constraint(
                    lessThanOrEqualTo: isAlreadyTakenTodayCheckbox.leadingAnchor,
                    constant: -8,
                ),
            ]
        }

        counterLabel.setupConstraints {
            [
                $0.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -commonOffset),
                $0.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: commonOffset),
                $0.trailingAnchor.constraint(
                    lessThanOrEqualTo: isAlreadyTakenTodayCheckbox.leadingAnchor,
                    constant: -8,
                ),
            ]
        }

        isAlreadyTakenTodayCheckbox.setupConstraints {
            let checkboxSize: CGFloat = 36
            return [
                $0.centerYAnchor.constraint(equalTo: innerView.centerYAnchor),
                $0.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -25),
                $0.heightAnchor.constraint(equalToConstant: checkboxSize),
                $0.widthAnchor.constraint(equalToConstant: checkboxSize),
            ]
        }
    }
}
