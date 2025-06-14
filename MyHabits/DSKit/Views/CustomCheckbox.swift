//
//  CustomCheckbox.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 11.06.2025.
//

import UIKit

class CustomCheckbox: UIView {
    private let shapeLayer = CAShapeLayer()
    private let checkmarkLabel = UILabel()
    private var isChecked: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    var checkboxTintColor: UIColor = .systemBlue {
        didSet {
            updateAppearance()
        }
    }

    var checkedChangeListener: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        frame = CGRect(x: 0, y: 0, width: 36, height: 36)

        let path = UIBezierPath(ovalIn: bounds.insetBy(dx: 1, dy: 1))
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = checkboxTintColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)

        checkmarkLabel.frame = bounds
        checkmarkLabel.text = "✓"
        checkmarkLabel.textAlignment = .center
        checkmarkLabel.font = UIFont.systemFont(ofSize: 17)
        checkmarkLabel.textColor = .white
        checkmarkLabel.isHidden = true
        addSubview(checkmarkLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggle))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }

    private func updateAppearance() {
        shapeLayer.strokeColor = checkboxTintColor.cgColor
        shapeLayer.fillColor = isChecked ? checkboxTintColor.cgColor : UIColor.clear.cgColor
        checkmarkLabel.isHidden = !isChecked
    }

    @objc private func toggle() {
        if let checkedChangeListener {
            checkedChangeListener(!isChecked)
        }
    }

    func setChecked(_ checked: Bool, animated: Bool = false) {
        isChecked = checked
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.updateAppearance()
            }
        } else {
            updateAppearance()
        }
    }
}
