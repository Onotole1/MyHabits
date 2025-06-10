//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 07.06.2025.
//

import UIKit

class HabitsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped)
        )
    }

    @objc func addButtonTapped() {
        print("Кнопка '+' нажата")
    }
}
