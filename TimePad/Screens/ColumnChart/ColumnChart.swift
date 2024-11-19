//
//  ColumnChart.swift
//  TimePad
//
//  Created by Melik Demiray on 19.11.2024.
//

import UIKit

class ColumnChart: UIView {

  private var columns: [UIView] = []
  private var labels: [UILabel] = []
  private var durationLabels: [UILabel] = []
  private var values: [Int] = [0, 0, 0, 0]  // Store durations for each type
  private let types = [Constants.work, Constants.workout, Constants.reading, Constants.coding]
  private let colors: [UIColor] = [
    UIColor.hexStringToUIColor(hex: Colors.purple),
    UIColor.hexStringToUIColor(hex: Colors.orange),
    UIColor.hexStringToUIColor(hex: Colors.green),
    UIColor.hexStringToUIColor(hex: Colors.red),
  ]

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupChart()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupChart()
  }

  private func setupChart() {
    // Create columns and labels
    for i in 0..<4 {
      let column = UIView()
      column.backgroundColor = colors[i]
      column.layer.cornerRadius = 8
      column.tag = i
      column.isUserInteractionEnabled = true

      let label = UILabel()
      label.text = types[i]
      label.textAlignment = .center
      label.textColor = .white
      label.font = .boldSystemFont(ofSize: 12)

      columns.append(column)
      labels.append(label)

      addSubview(column)
      addSubview(label)

      // Add duration label
      let durationLabel = UILabel()
      durationLabel.textAlignment = .center
      durationLabel.font = .boldSystemFont(ofSize: 12)
      durationLabel.textColor = .white

      durationLabels.append(durationLabel)
      addSubview(durationLabel)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let columnWidth = bounds.width / 5
    let spacing = columnWidth / 4
    let maxHeight = bounds.height - 40

    let maxValue = values.max() ?? 1

    for i in 0..<columns.count {
      let columnHeight = maxValue == 0 ? 0 : (CGFloat(values[i]) / CGFloat(maxValue)) * maxHeight
      let x = spacing + CGFloat(i) * (columnWidth + spacing)

      // Position column
      columns[i].frame = CGRect(
        x: x,
        y: maxHeight - columnHeight,
        width: columnWidth,
        height: columnHeight)

      // Position type label
      labels[i].frame = CGRect(
        x: x,
        y: maxHeight + 5,
        width: columnWidth,
        height: 30)

      // Position duration label
      let hours = values[i] / 3600
      let minutes = (values[i] % 3600) / 60
      durationLabels[i].text = "\(hours)h \(minutes)m"
      durationLabels[i].frame = CGRect(
        x: x,
        y: maxHeight - columnHeight - 20,  // Position above column
        width: columnWidth,
        height: 20)
    }
  }

  func updateValues(_ newValues: [Int]) {
    print("ColumnChart received new values: \(newValues)")  // Debug print
    values = newValues

    // Update duration labels
    for i in 0..<durationLabels.count {
      let hours = values[i] / 3600
      let minutes = (values[i] % 3600) / 60
      durationLabels[i].text = "\(hours)h \(minutes)m"
    }

    // Force layout update
    setNeedsLayout()
    layoutIfNeeded()
  }

}
