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
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)

        let addWorkVC = AddWorkVC()
        let addWorkNav = UINavigationController(rootViewController: addWorkVC)
        addWorkNav.tabBarItem = UITabBarItem(title: "Add Task", image: UIImage(systemName: "plus"), tag: 0)

        let historyVC = HistoryVC()
        let historyNav = UINavigationController(rootViewController: historyVC)
        historyNav.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock"), tag: 2)

        let homeViewModel = HomeVM()
        homeVC.viewModel = homeViewModel

        let addWorkViewModel = AddWorkVM()
        addWorkVC.viewModel = addWorkViewModel

        let historyViewModel = HistoryVM()
        historyVC.viewModel = historyViewModel

        viewControllers = [addWorkNav, homeNav, historyNav]

        selectedIndex = 1
    }
}
