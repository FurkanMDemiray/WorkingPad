//
//  HomeViewController.swift
//  TimePad
//
//  Created by Melik Demiray on 24.09.2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var timerCardView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        timerCardView.layer.cornerRadius = 10
        timerCardView.layer.shadowColor = UIColor.black.cgColor
        timerCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        timerCardView.layer.shadowOpacity = 0.2
        timerCardView.layer.shadowRadius = 2
    }

    private func configureTablaView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.projectTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.projectTableViewCell)
    }


    @IBAction func seeAllButtonClicked(_ sender: Any) {
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

enum Constants {
    static let projectTableViewCell = "ProjectTableViewCell"
}
