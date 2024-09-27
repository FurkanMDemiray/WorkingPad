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

        let addWorkVC = AddWorkVC()
        let addWorkNav = UINavigationController(rootViewController: addWorkVC)
        addWorkNav.tabBarItem = UITabBarItem(title: "Add Work", image: UIImage(systemName: "plus"), tag: 1)

        let homeViewModel = HomeVM()
        homeVC.viewModel = homeViewModel

        let addWorkViewModel = AddWorkVM()
        addWorkVC.viewModel = addWorkViewModel

        viewControllers = [homeNav, addWorkNav]
    }
}
