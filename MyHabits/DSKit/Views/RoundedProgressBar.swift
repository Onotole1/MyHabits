//
//  RoundedProgressBar.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 11.06.2025.
//

import UIKit

class RoundedProgressBar: UIView {
    private let progressLayer = CALayer()
    private let backgroundLayer = CALayer()

    var progress: Float = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var progressColor: UIColor = .systemBlue {
        didSet {
            progressLayer.backgroundColor = progressColor.cgColor
        }
    }

    var trackColor: UIColor = .lightGray {
        didSet {
            backgroundLayer.backgroundColor = trackColor.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        // Настройка фонового слоя (track)
        backgroundLayer.backgroundColor = trackColor.cgColor
        backgroundLayer.masksToBounds = true
        layer.addSublayer(backgroundLayer)

        // Настройка слоя прогресса
        progressLayer.backgroundColor = progressColor.cgColor
        progressLayer.masksToBounds = true
        layer.addSublayer(progressLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Устанавливаем размеры и скругление для фонового слоя
        backgroundLayer.frame = bounds
        backgroundLayer.cornerRadius = bounds.height / 2

        // Устанавливаем размеры и скругление для слоя прогресса
        let progressWidth = bounds.width * CGFloat(progress)
        progressLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)
        progressLayer.cornerRadius = bounds.height / 2
    }
}
