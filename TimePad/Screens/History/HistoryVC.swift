//
//  HistoryVC.swift
//  TimePad
//
//  Created by Melik Demiray on 4.11.2024.
//

import UIKit

final class HistoryVC: UIViewController {

  @IBOutlet private weak var tableView: UITableView!

  @IBOutlet weak var emptyLabel: UILabel!

  var viewModel: HistoryVMProtocol! {
    didSet {
      viewModel.delegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.didFetchHistoryModels()
  }

  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.register(
      UINib(nibName: Constants.projectCell, bundle: nil),
      forCellReuseIdentifier: Constants.projectCell)
  }

}
//MARK: - TableView
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.getHistoryModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: Constants.projectCell, for: indexPath)
      as! ProjectCell
    cell.configure(with: viewModel.getHistoryModels[indexPath.row], true)
    return cell
  }

  // delete cell
  func tableView(
    _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    if editingStyle == .delete {
      self.showAreYouSureAlert(
        title: Constants.areYouSureAlertActionTitle,
        message: Constants.areYouSureAlertMessage,
        actionTitle: Constants.areYouSureAlertActionTitle,
        completion: { [weak self] in
          guard let self else { return }
          viewModel.deleteHistoryModel(at: indexPath.row)
        })
    }
    viewModel.didFetchHistoryModels()
  }

}
//MARK: - HistoryVMDelegate
extension HistoryVC: HistoryVMDelegate {
  func updateTableView() {
    tableView.reloadData()
  }

  func showEmptyView() {
    emptyLabel.isHidden = false
  }

  func hideEmptyView() {
    emptyLabel.isHidden = true
  }
}
