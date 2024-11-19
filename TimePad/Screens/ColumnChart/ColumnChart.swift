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

      let tap = UITapGestureRecognizer(target: self, action: #selector(columnTapped(_:)))
      column.addGestureRecognizer(tap)

      let label = UILabel()
      label.text = types[i]
      label.textAlignment = .center
      label.font = .systemFont(ofSize: 12)

      columns.append(column)
      labels.append(label)

      addSubview(column)
      addSubview(label)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let columnWidth = bounds.width / 5
    let spacing = columnWidth / 4
    let maxHeight = bounds.height - 40  // Leave space for labels

    // Find max value for scaling
    let maxValue = values.max() ?? 1

    for i in 0..<columns.count {
      let columnHeight = maxValue == 0 ? 0 : (CGFloat(values[i]) / CGFloat(maxValue)) * maxHeight
      let x = spacing + CGFloat(i) * (columnWidth + spacing)

      columns[i].frame = CGRect(
        x: x,
        y: maxHeight - columnHeight,
        width: columnWidth,
        height: columnHeight)

      labels[i].frame = CGRect(
        x: x,
        y: maxHeight + 5,
        width: columnWidth,
        height: 30)
    }
  }

  func updateValues(_ newValues: [Int]) {
    values = newValues
    setNeedsLayout()
  }

  @objc private func columnTapped(_ sender: UITapGestureRecognizer) {
    guard let column = sender.view,
      let index = columns.firstIndex(of: column)
    else { return }

    let hours = values[index] / 3600
    let minutes = (values[index] % 3600) / 60

    let alert = UIAlertController(
      title: types[index],
      message: "Total duration: \(hours)h \(minutes)m",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))

    if let viewController = findViewController() {
      viewController.present(alert, animated: true)
    }
  }

  private func findViewController() -> UIViewController? {
    var responder: UIResponder? = self
    while let nextResponder = responder?.next {
      if let viewController = nextResponder as? UIViewController {
        return viewController
      }
      responder = nextResponder
    }
    return nil
  }

}
