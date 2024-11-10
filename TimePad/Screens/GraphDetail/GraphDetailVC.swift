//
//  GraphDetailVC.swift
//  TimePad
//
//  Created by Melik Demiray on 8.11.2024.
//

import UIKit

final class GraphDetailVC: UIViewController {

    var chartView = LineChart()
    let segmentedControl = UISegmentedControl(items: ["Günlük", "Aylık", "Yıllık"])

    var viewModel: GraphDetailVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchWorkModels()
        updateChart(for: .daily)
        configureChartView()
        // check line chart is exist

    }

    private func configureChartView() {
        chartView = LineChart(frame: CGRect(x: 0, y: 30, width: view.bounds.width, height: view.bounds.height))
        chartView.lineColor = .systemBlue
        chartView.pointColor = .white
        chartView.gridColor = UIColor.hexStringToUIColor(hex: Colors.background).withAlphaComponent(0.3)
        chartView.textColor = .white
        chartView.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
    }

    func setupUI() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        view.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            chartView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            chartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ])

        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }

    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        let selectedScope: TimeScope = {
            switch sender.selectedSegmentIndex {
            case 0: return .daily
            case 1: return .monthly
            case 2: return .yearly
            default: return .daily
            }
        }()

        updateChart(for: selectedScope)
    }



}

extension GraphDetailVC: GraphDetailVMDelegate {
    func updateData(with data: [DataPoint]) {
        chartView.updateDataPoints(data)
    }

    func updateChart(for scope: TimeScope) {
        func updateChart(for scope: TimeScope) {
            let filteredData = viewModel.filterData(for: scope)
            chartView.updateDataPoints(filteredData)
        }
    }

    func updateCollectionView() {
        // update collection view
    }
}

enum TimeScope {
    case daily, monthly, yearly
}
