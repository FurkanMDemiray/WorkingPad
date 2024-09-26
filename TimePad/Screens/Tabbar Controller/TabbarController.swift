//
//  TabbarController.swift
//  TimePad
//
//  Created by Melik Demiray on 24.09.2024.
//

import Foundation
import UIKit

final class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeVC()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let timerVC = TimerVC()
        let timerNav = UINavigationController(rootViewController: timerVC)
        timerNav.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "timer"), tag: 1)

        let addWorkVC = AddWorkVC()
        let addWorkNav = UINavigationController(rootViewController: addWorkVC)
        addWorkNav.tabBarItem = UITabBarItem(title: "Add Work", image: UIImage(systemName: "plus"), tag: 2)

        viewControllers = [homeNav, timerNav, addWorkNav]
    }
}
