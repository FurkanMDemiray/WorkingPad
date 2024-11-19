//
//  GraphDetailVC.swift
//  TimePad
//
//  Created by Melik Demiray on 8.11.2024.
//

import UIKit

final class GraphDetailVC: UIViewController {

  var chartView = LineChart()
  var columnChart = ColumnChart()
  let segmentedControl = UISegmentedControl(
    items: SegmentedControlItems.allCases.map { $0.rawValue })

  var viewModel: GraphDetailVMProtocol! {
    didSet {
      viewModel.delegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureChartView()
    setupUI()
    viewModel.fetchWorkModels()
    updateChart(for: .daily)
  }

  private func configureChartView() {
    chartView = LineChart()
    chartView.translatesAutoresizingMaskIntoConstraints = false

    chartView.lineColor = .systemBlue
    chartView.pointColor = .white
    chartView.gridColor = UIColor.hexStringToUIColor(hex: Colors.background).withAlphaComponent(0.3)
    chartView.textColor = .white
    chartView.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
  }

  private func configureColumnChart() {
    columnChart = ColumnChart()
    columnChart.translatesAutoresizingMaskIntoConstraints = false
    columnChart.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
  }

  private func setupUI() {
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(
      self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)

    view.addSubview(segmentedControl)
    view.addSubview(chartView)

    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      chartView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
      chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      chartView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
    ])

    view.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
  }

  @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
    let selectedScope: TimeScope = {
      switch sender.selectedSegmentIndex {
      case 0: return .daily
      case 1: return .weekly
      case 2: return .monthly
      case 3: return .yearly
      default: return .daily
      }
    }()

    print("Selected scope: \(selectedScope)")
    updateChart(for: selectedScope)
  }

}

extension GraphDetailVC: GraphDetailVMDelegate {
  func updateData(with data: [DataPoint]) {
    print("updateData called with \(data.count) points")
    let scope = TimeScope(rawValue: segmentedControl.selectedSegmentIndex) ?? .daily
    chartView.updateDataPoints(data, scope: scope)
  }

  func updateChart(for scope: TimeScope) {
    let filteredData = viewModel.filterData(for: scope)
    print("updateChart called for scope: \(scope) with \(filteredData.count) points")
    chartView.updateDataPoints(filteredData, scope: scope)
  }

  func updateCollectionView() {
    // Not implemented yet
  }
}

enum TimeScope: Int {
  case daily = 0
  case weekly = 1
  case monthly = 2
  case yearly = 3
}

enum SegmentedControlItems: String {
  case daily = "Daily"
  case weekly = "Weekly"
  case monthly = "Monthly"
  case yearly = "Yearly"
}
