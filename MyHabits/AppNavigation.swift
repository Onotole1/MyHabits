//
//  AppNavigation.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 07.06.2025.
//

import UIKit

struct AppNavigation {
    static func createMainViewController() -> UIViewController {
        let uitabbarcontroller = UITabBarController()

        let habitsNavigationViewController = UINavigationController(rootViewController: HabitsViewController())
        habitsNavigationViewController.tabBarItem.image = UIImage(named: "HabitsTabIcon")
        habitsNavigationViewController.tabBarItem.title = "Привычки"

        let infoNavigationViewController = UINavigationController(rootViewController: InfoViewController())
        infoNavigationViewController.tabBarItem.image = UIImage(systemName: "info.circle.fill")
        infoNavigationViewController.tabBarItem.title = "Информация"

        uitabbarcontroller.viewControllers = [habitsNavigationViewController, infoNavigationViewController]

        return uitabbarcontroller
    }
}
