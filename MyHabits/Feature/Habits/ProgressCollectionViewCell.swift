//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 11.06.2025.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    var progress: Float = 0 {
        didSet {
            progressBar.progress = progress
            progressPercentageLabel.setStyledText("\(Int(progress * 100))%", with: .footNoteStatus)
            let progressText = NSLocalizedString(
                progress == 1 ? "habits_screen_progress_complete" : "habits_screen_progress_todo",
                comment: "",
            )
            titleLabel.setStyledText(progressText, with: .footNoteStatus)
        }
    }

    private lazy var progressBar: RoundedProgressBar = {
        let progressBar = RoundedProgressBar()

        progressBar.progressColor = UIColor(named: "AccentColor")!
        progressBar.trackColor = UIColor(named: "ProgressBackgroundColor")!

        return progressBar
    }()

    private lazy var titleLabel: UILabel = {
        UILabel()
    }()

    private lazy var progressPercentageLabel: UILabel = {
        UILabel()
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        tuneView()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func tuneView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
    }

    private func addSubviews() {
        [progressBar, titleLabel, progressPercentageLabel].forEach(contentView.addSubview)
    }

    private func setupConstraints() {
        titleLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            ]
        }

        progressPercentageLabel.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: titleLabel.topAnchor),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            ]
        }

        progressBar.setupConstraints {
            [
                $0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
                $0.heightAnchor.constraint(equalToConstant: 7),
            ]
        }
    }
}
