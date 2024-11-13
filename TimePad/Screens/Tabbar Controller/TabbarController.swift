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
    homeNav.tabBarItem = UITabBarItem(
      title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
    homeNav.tabBarItem.setTitleTextAttributes(
      [.font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .normal)
    homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)

    let addWorkVC = AddWorkVC()
    let addWorkNav = UINavigationController(rootViewController: addWorkVC)
    addWorkNav.tabBarItem = UITabBarItem(
      title: "Add Task", image: UIImage(systemName: "plus"), tag: 0)

    let historyVC = HistoryVC()
    let historyNav = UINavigationController(rootViewController: historyVC)
    historyNav.tabBarItem = UITabBarItem(
      title: "History", image: UIImage(systemName: "clock"), tag: 2)

    let graphVC = GraphsVC()
    let graphNav = UINavigationController(rootViewController: graphVC)
    graphNav.tabBarItem = UITabBarItem(
      title: "Graphs", image: UIImage(systemName: "chart.bar"), tag: 3)

    let stopwatchVC = StopwatchVC()
    let stopwatchNav = UINavigationController(rootViewController: stopwatchVC)
    stopwatchNav.tabBarItem = UITabBarItem(
      title: "Stopwatch", image: UIImage(systemName: "stopwatch"), tag: 4)

    let homeViewModel = HomeVM()
    homeVC.viewModel = homeViewModel

    let addWorkViewModel = AddWorkVM()
    addWorkVC.viewModel = addWorkViewModel

    let historyViewModel = HistoryVM()
    historyVC.viewModel = historyViewModel

    let graphViewModel = GraphsVM()
    graphVC.viewModel = graphViewModel

    viewControllers = [stopwatchNav, addWorkNav, homeNav, graphNav, historyNav]

    selectedIndex = 2
  }
}
