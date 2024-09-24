//
//  TabbarController.swift
//  TimePad
//
//  Created by Melik Demiray on 24.09.2024.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)


        viewControllers = [homeNav]
    }
}
