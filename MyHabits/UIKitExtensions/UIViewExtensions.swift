//
//  UIViewExtensions.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 07.06.2025.
//

import UIKit

extension UIView {
    @discardableResult
    func setupConstraints(_ constraints: (Self) -> [NSLayoutConstraint]) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let constraintsToActivate = constraints(self)
        NSLayoutConstraint.activate(constraintsToActivate)
        return self
    }
}
