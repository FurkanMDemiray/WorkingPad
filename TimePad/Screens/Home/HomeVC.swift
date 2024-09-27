//
//  HomeViewController.swift
//  TimePad
//
//  Created by Melik Demiray on 24.09.2024.
//

import UIKit

final class HomeVC: UIViewController {

    @IBOutlet private weak var timerCardView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var projectLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var seeAllLabel: UILabel!
    @IBOutlet private weak var playImage: UIImageView!

    var viewModel: HomeVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.didFetchWorkModels()
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
        return viewModel.getWorkModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.projectCell, for: indexPath) as! ProjectCell
        cell.configure(with: viewModel.getWorkModels[indexPath.row])
        return cell
    }

    // delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showAreYouSureAlert(
                title: "Are you sure?",
                message: "Do you want to delete this work?",
                actionTitle: "Delete",
                completion: { [weak self] in
                    guard let self else { return }
                    viewModel.deleteWordModel(at: indexPath.row)
                })
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.getWorkModels.count >= 4 {
            return tableView.frame.height / CGFloat(self.tableView(tableView, numberOfRowsInSection: 0))
        } else {
            return tableView.frame.height / 4
        }
    }
}

extension HomeVC: HomeVMDelegate {
    func updateTablaView() {
        tableView.reloadData()
    }
}

private enum Constants {
    static let projectCell = "ProjectCell"
}
