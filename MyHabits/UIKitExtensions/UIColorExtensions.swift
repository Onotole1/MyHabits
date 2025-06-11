//
//  UIColorExtensions.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 11.06.2025.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
