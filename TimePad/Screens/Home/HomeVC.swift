//
//  HomeViewController.swift
//  TimePad
//
//  Created by Melik Demiray on 24.09.2024.
//

import UIKit

final class HomeVC: UIViewController {

  //MARK: Outlets
  @IBOutlet private weak var timerCardView: UIView!
  @IBOutlet private weak var timerLabel: UILabel!
  @IBOutlet private weak var projectLabel: UILabel!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var seeAllLabel: UILabel!
  @IBOutlet private weak var playImage: UIImageView!
  @IBOutlet private weak var emptyDataLabel: UILabel!

  var viewModel: HomeVMProtocol! {
    didSet {
      viewModel.delegate = self
    }
  }

  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupConfigures()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.didFetchWorkModels()
    viewModel.didFetchLastWork()
    setInnerOfCardView()
  }

  //MARK: Configures
  private func configureUI() {
    timerCardView.layer.cornerRadius = 10
    timerCardView.layer.shadowColor = UIColor.black.cgColor
    timerCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
    timerCardView.layer.shadowOpacity = 0.2
    timerCardView.layer.shadowRadius = 2

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeAllTapped))
    seeAllLabel.isUserInteractionEnabled = true
    seeAllLabel.addGestureRecognizer(tapGesture)
  }

  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.register(
      UINib(nibName: Constants.projectCell, bundle: nil),
      forCellReuseIdentifier: Constants.projectCell)
  }

  private func setInnerOfCardView() {
    if viewModel.getFinishString != "" {
      projectLabel.text = viewModel.getFinishString
    } else {
      projectLabel.text = viewModel.getLastWork.title
    }
    timerLabel.text = viewModel.getLastWorkTime

  }

  private func configureInnerOfCardView() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(timerCardTapped))
    timerCardView.isUserInteractionEnabled = true
    timerCardView.addGestureRecognizer(tapGesture)
  }

  private func setupConfigures() {
    configureUI()
    configureTableView()
  }

  //MARK: Navigate
  private func navigateToTimerVC(at index: Int) {
    let timerVC = TimerVC()
    timerVC.workModel = viewModel.getWorkModels[index]
    navigationController?.pushViewController(timerVC, animated: true)
  }

  //MARK: - Actions
  @objc private func seeAllTapped() {
    print("See all tapped")
  }

  @objc private func timerCardTapped() {
    // Find last work depending on title
    guard let lastWorkTitle = projectLabel.text,
      let lastWorkTime = timerLabel.text
    else { return }

    // Find index of last work model depending on title and time
    if let index = viewModel.getWorkModels.firstIndex(where: {
      $0.title == lastWorkTitle && viewModel.getLastWorkTime == lastWorkTime
    }) {
      navigateToTimerVC(at: index)
    }
  }
}

//MARK: - TableViewDelegate
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.getWorkModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: Constants.projectCell, for: indexPath)
      as! ProjectCell
    cell.configure(with: viewModel.getWorkModels[indexPath.row], false)
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
          viewModel.deleteWordModel(at: indexPath.row)
        })
    }
    viewModel.didFetchWorkModels()
  }

  //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //        if viewModel.getWorkModels.count == 4 {
  //            return tableView.frame.height / CGFloat(self.tableView(tableView, numberOfRowsInSection: 0))
  //        } else {
  //            return tableView.frame.height / 4
  //        }
  //    }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigateToTimerVC(at: indexPath.row)
  }
}
//MARK: - HomeVMDelegate
extension HomeVC: HomeVMDelegate {
  func updateTimerCard() {
    configureInnerOfCardView()
  }

  func showEmptyView() {
    emptyDataLabel.isHidden = false
  }

  func hideEmptyView() {
    emptyDataLabel.isHidden = true
  }

  func updateTableView() {
    tableView.reloadData()
    setInnerOfCardView()
  }
}
