//
//  HomeViewController.swift
//  TimePad
//
//  Created by Melik Demiray on 24.09.2024.
//

import UIKit

final class HomeVC: UIViewController {

    @IBOutlet weak var timerCardView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seeAllLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }

    private func configureUI() {
        timerCardView.layer.cornerRadius = 10
        timerCardView.layer.shadowColor = UIColor.black.cgColor
        timerCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        timerCardView.layer.shadowOpacity = 0.2
        timerCardView.layer.shadowRadius = 2

        let tapMesture = UITapGestureRecognizer(target: self, action: #selector(seeAllTapped))
        seeAllLabel.isUserInteractionEnabled = true
        seeAllLabel.addGestureRecognizer(tapMesture)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: Constants.projectCell, bundle: nil), forCellReuseIdentifier: Constants.projectCell)
    }

    //MARK: - Actions
    @objc private func seeAllTapped() {
        print("See all tapped")
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.projectCell, for: indexPath) as! ProjectCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(self.tableView(tableView, numberOfRowsInSection: 0))
    }
}

enum Constants {
    static let projectCell = "ProjectCell"
}
