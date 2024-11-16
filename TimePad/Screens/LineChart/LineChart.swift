//
//  LineChart.swift
//  TimePad
//
//  Created by Melik Demiray on 10.11.2024.
//

import UIKit

// MARK: - Data Model
struct DataPoint {
  let date: Date
  let hour: Int
  let minute: Int

  var timeValue: Double {
    return Double(hour) + Double(minute) / 60.0
  }

  var formattedTime: String {
    String(format: "%02d:%02d", hour, minute)
  }
}

// MARK: - LineChart Class
final class LineChart: UIView {
  // MARK: - Properties
  private var dataPoints: [DataPoint] = []
  private var selectedPointIndex: Int?
  private var valueLabel: UILabel?

  // Add empty state label
  lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "No data in this time range"
    label.textColor = .white
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.numberOfLines = 0
    label.isHidden = true
    return label
  }()

  // MARK: - Customization Properties
  var lineColor: UIColor = .systemBlue {
    didSet { setNeedsDisplay() }
  }
  var pointColor: UIColor = .white {
    didSet { setNeedsDisplay() }
  }
  var gridColor: UIColor = .gray.withAlphaComponent(0.3) {
    didSet { setNeedsDisplay() }
  }
  var textColor: UIColor = .white {
    didSet { setNeedsDisplay() }
  }

  // MARK: - Layout Properties
  private let topMargin: CGFloat = 40
  private let bottomMargin: CGFloat = 60
  private let leftMargin: CGFloat = 40
  private let rightMargin: CGFloat = 20
  private let pointRadius: CGFloat = 4
  private let numberOfHorizontalLines = 5
  private let labelAngle: CGFloat = -45 * .pi / 180
  private let hitTestRadius: CGFloat = 20

  var emptyStateMessage: String = "No data available" {
    didSet {
      emptyLabel.text = emptyStateMessage
    }
  }

  // Add a property to track current scope
  private var currentScope: TimeScope = .daily

  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGestureRecognizers()
    setupValueLabel()
    setupEmptyLabel()
    backgroundColor = .clear
    isOpaque = false
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupGestureRecognizers()
    setupValueLabel()
    setupEmptyLabel()
    backgroundColor = .clear
    isOpaque = false
  }

  // MARK: - Setup Methods
  private func setupGestureRecognizers() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    addGestureRecognizer(tapGesture)
  }

  private func setupValueLabel() {
    valueLabel = UILabel()
    valueLabel?.backgroundColor = lineColor.withAlphaComponent(0.9)
    valueLabel?.textColor = .white
    valueLabel?.font = .systemFont(ofSize: 12, weight: .medium)
    valueLabel?.textAlignment = .center
    valueLabel?.layer.cornerRadius = 8
    valueLabel?.layer.masksToBounds = true
    valueLabel?.numberOfLines = 0
    valueLabel?.isHidden = true
    if let valueLabel = valueLabel {
      addSubview(valueLabel)
    }
  }

  private func setupEmptyLabel() {
    addSubview(emptyLabel)

    NSLayoutConstraint.activate([
      emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      emptyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      emptyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
    ])
  }

  // MARK: - Drawing Methods
  override func draw(_ rect: CGRect) {
    if dataPoints.isEmpty {
      emptyLabel.isHidden = false
      return
    }

    emptyLabel.isHidden = true
    guard let context = UIGraphicsGetCurrentContext() else { return }

    let chartRect = CGRect(
      x: rect.minX + leftMargin,
      y: rect.minY + topMargin,
      width: rect.width - leftMargin - rightMargin,
      height: rect.height - topMargin - bottomMargin)

    drawGrid(in: chartRect, context: context)
    drawAxes(in: chartRect, context: context)
    drawTimeLabels(in: chartRect, context: context)
    drawValueLabels(in: chartRect)
    drawLineAndPoints(in: chartRect)
    drawGradient(in: chartRect, context: context)
  }

  private func drawGrid(in rect: CGRect, context: CGContext) {
    let path = UIBezierPath()

    // Vertical lines
    let xStep = rect.width / CGFloat(dataPoints.count - 1)
    for i in 0...dataPoints.count - 1 {
      let x = rect.minX + CGFloat(i) * xStep
      path.move(to: CGPoint(x: x, y: rect.minY))
      path.addLine(to: CGPoint(x: x, y: rect.maxY))
    }

    // Horizontal lines
    let yStep = rect.height / CGFloat(numberOfHorizontalLines - 1)
    for i in 0...numberOfHorizontalLines - 1 {
      let y = rect.minY + CGFloat(i) * yStep
      path.move(to: CGPoint(x: rect.minX, y: y))
      path.addLine(to: CGPoint(x: rect.maxX, y: y))
    }

    gridColor.setStroke()
    path.lineWidth = 0.5
    path.stroke()
  }

  private func drawAxes(in rect: CGRect, context: CGContext) {
    let axesPath = UIBezierPath()

    // X-axis
    axesPath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    axesPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

    // Y-axis
    axesPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
    axesPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

    textColor.setStroke()
    axesPath.lineWidth = 2
    axesPath.stroke()
  }

  private func drawTimeLabels(in rect: CGRect, context: CGContext) {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")

    switch currentScope {
    case .daily, .weekly:
      // Keep existing behavior for daily and weekly
      drawAllTimeLabels(in: rect, context: context, formatter: formatter)
    case .monthly:
      // Show only every 5th day
      drawReducedTimeLabels(in: rect, context: context, formatter: formatter, interval: 5)
    case .yearly:
      // Show only every 3rd month
      drawReducedTimeLabels(in: rect, context: context, formatter: formatter, interval: 3)
    }
  }

  private func drawAllTimeLabels(in rect: CGRect, context: CGContext, formatter: DateFormatter) {
    // Set format based on scope
    switch currentScope {
    case .daily:
      formatter.dateFormat = "HH:mm"
    case .weekly:
      formatter.dateFormat = "EEE"
    default:
      break
    }

    let xStep = rect.width / CGFloat(dataPoints.count - 1)
    drawLabels(
      in: rect, context: context, formatter: formatter, xStep: xStep,
      indices: Array(0..<dataPoints.count))
  }

  private func drawReducedTimeLabels(
    in rect: CGRect, context: CGContext, formatter: DateFormatter, interval: Int
  ) {
    // Set format based on scope
    switch currentScope {
    case .monthly:
      formatter.dateFormat = "d MMM"
    case .yearly:
      formatter.dateFormat = "MMM"
    default:
      break
    }

    // Calculate indices to show (every nth point)
    var indicesToShow: [Int] = []

    // Always show first and last point
    if !dataPoints.isEmpty {
      indicesToShow.append(0)

      // Add intermediate points based on interval
      for i in stride(from: interval, to: dataPoints.count, by: interval) {
        indicesToShow.append(i)
      }

      // Add last point if not already included
      if let lastIndex = indicesToShow.last, lastIndex != dataPoints.count - 1 {
        indicesToShow.append(dataPoints.count - 1)
      }
    }

    let xStep = rect.width / CGFloat(dataPoints.count - 1)
    drawLabels(
      in: rect, context: context, formatter: formatter, xStep: xStep, indices: indicesToShow)
  }

  private func drawLabels(
    in rect: CGRect, context: CGContext, formatter: DateFormatter, xStep: CGFloat, indices: [Int]
  ) {
    for index in indices {
      guard index < dataPoints.count else { continue }

      let point = dataPoints[index]
      let x = (rect.minX + CGFloat(index) * xStep) - 22
      let timeString = formatter.string(from: point.date)

      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 10),
        .foregroundColor: textColor,
      ]

      // Get text size for clipping check
      let size = timeString.size(withAttributes: attributes)
      let rotatedWidth = abs(size.width * cos(labelAngle)) + abs(size.height * sin(labelAngle))
      let endX = x + rotatedWidth

      // Only draw if the label ends before the chart's right boundary
      if endX <= rect.maxX {
        context.saveGState()
        context.translateBy(x: x, y: rect.maxY + 15)
        context.rotate(by: labelAngle)
        timeString.draw(at: CGPoint(x: 0, y: 12), withAttributes: attributes)
        context.restoreGState()
      }
    }
  }

  private func drawValueLabels(in rect: CGRect) {
    // Calculate the actual min and max values from the data
    let values = dataPoints.map { $0.timeValue }
    let minValue = values.min() ?? 0
    let maxValue = values.max() ?? 24

    // Calculate a nice range that includes the min and max values
    let (adjustedMin, adjustedMax, step) = calculateNiceRange(min: minValue, max: maxValue)
    let numberOfSteps = Int(ceil((adjustedMax - adjustedMin) / step))

    let yStep = rect.height / CGFloat(numberOfSteps)

    for i in 0...numberOfSteps {
      let y = rect.minY + CGFloat(i) * yStep
      let value = adjustedMax - Double(i) * step

      // Format the value in HH:mm format
      let valueString = formatAxisValue(value)

      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 10),
        .foregroundColor: textColor,
      ]

      let size = valueString.size(withAttributes: attributes)
      let labelPoint = CGPoint(
        x: rect.minX - size.width - 5,
        y: y - size.height / 2)

      valueString.draw(at: labelPoint, withAttributes: attributes)
    }
  }

  private func formatAxisValue(_ value: Double) -> String {
    // If value is less than 1 hour, show in minutes
    if value < 1.0 {
      let minutes = Int(value * 60)
      return String(format: "%dm", minutes)
    }

    // If value has no minutes component (whole hour)
    if value.truncatingRemainder(dividingBy: 1.0) == 0 {
      return String(format: "%dh", Int(value))
    }

    // If value is less than 10 hours, show hours and minutes
    if value < 10.0 {
      let hours = Int(value)
      let minutes = Int((value - Double(hours)) * 60)
      return String(format: "%d:%02d", hours, minutes)
    }

    // For larger values, show with one decimal place
    return String(format: "%.1fh", value)
  }

  private func calculateNiceRange(min: Double, max: Double) -> (
    min: Double, max: Double, step: Double
  ) {
    let range = max - min

    // If the range is 0, create a small range around the value
    if range == 0 {
      let value = min
      // If value is less than 1 hour, use 15-minute steps
      if value < 1.0 {
        return (0, 1, 0.25)  // 0.25 represents 15 minutes
      }
      // Otherwise use 30-minute steps
      return (floor(value), ceil(value) + 1, 0.5)
    }

    // Calculate step size based on range
    let possibleSteps: [Double]
    if range < 1.0 {
      // For small ranges (< 1 hour), use minute-based steps
      possibleSteps = [0.25, 0.5]  // 15 and 30 minutes
    } else if range < 4.0 {
      // For medium ranges, use half-hour and hour steps
      possibleSteps = [0.5, 1.0, 2.0]
    } else {
      // For larger ranges, use hour-based steps
      possibleSteps = [1.0, 2.0, 3.0, 4.0, 6.0, 12.0, 24.0]
    }

    let roughStep = range / Double(numberOfHorizontalLines - 1)
    let step = possibleSteps.first { $0 >= roughStep } ?? 1.0

    let niceMin = floor(min / step) * step
    let niceMax = ceil(max / step) * step

    return (niceMin, niceMax, step)
  }

  private func drawLineAndPoints(in rect: CGRect) {
    let values = dataPoints.map { $0.timeValue }
    let minValue = values.min() ?? 0
    let maxValue = values.max() ?? 24
    let (adjustedMin, adjustedMax, _) = calculateNiceRange(min: minValue, max: maxValue)
    let valueRange = adjustedMax - adjustedMin

    let linePath = UIBezierPath()
    var points: [CGPoint] = []

    // Create points and line path
    for (index, data) in dataPoints.enumerated() {
      let x = rect.minX + rect.width * CGFloat(index) / CGFloat(dataPoints.count - 1)
      let normalizedValue = (data.timeValue - adjustedMin) / valueRange
      let y = rect.maxY - (CGFloat(normalizedValue) * rect.height)
      let point = CGPoint(x: x, y: y)
      points.append(point)

      if index == 0 {
        linePath.move(to: point)
      } else {
        linePath.addLine(to: point)
      }

      // Draw highlighted point if selected
      if index == selectedPointIndex {
        let highlightPath = UIBezierPath(
          arcCenter: point,
          radius: pointRadius * 2,
          startAngle: 0,
          endAngle: .pi * 2,
          clockwise: true)
        lineColor.withAlphaComponent(0.3).setFill()
        highlightPath.fill()
      }
    }

    // Draw line and points
    lineColor.setStroke()
    linePath.lineWidth = 2
    linePath.stroke()

    // Draw points
    for point in points {
      let pointPath = UIBezierPath(
        arcCenter: point,
        radius: pointRadius,
        startAngle: 0,
        endAngle: .pi * 2,
        clockwise: true)
      lineColor.setFill()
      pointPath.fill()

      let innerPointPath = UIBezierPath(
        arcCenter: point,
        radius: pointRadius - 2,
        startAngle: 0,
        endAngle: .pi * 2,
        clockwise: true)
      pointColor.setFill()
      innerPointPath.fill()
    }
  }

  private func drawGradient(in rect: CGRect, context: CGContext) {
    let gradientPath = UIBezierPath()
    var points: [CGPoint] = []

    let values = dataPoints.map { $0.timeValue }
    let minValue = values.min() ?? 0
    let maxValue = values.max() ?? 24
    let (adjustedMin, adjustedMax, _) = calculateNiceRange(min: minValue, max: maxValue)
    let valueRange = adjustedMax - adjustedMin

    for (index, data) in dataPoints.enumerated() {
      let x = rect.minX + rect.width * CGFloat(index) / CGFloat(dataPoints.count - 1)
      let normalizedValue = (data.timeValue - adjustedMin) / valueRange
      let y = rect.maxY - (CGFloat(normalizedValue) * rect.height)
      points.append(CGPoint(x: x, y: y))
    }

    gradientPath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    for (index, point) in points.enumerated() {
      if index == 0 {
        gradientPath.addLine(to: point)
      } else {
        gradientPath.addLine(to: point)
      }
    }
    gradientPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    gradientPath.close()

    // Create gradient
    let colors = [
      lineColor.withAlphaComponent(0.3).cgColor,
      lineColor.withAlphaComponent(0.0).cgColor,
    ]
    guard
      let gradient = CGGradient(
        colorsSpace: CGColorSpaceCreateDeviceRGB(),
        colors: colors as CFArray,
        locations: [0.0, 1.0])
    else { return }

    context.saveGState()
    gradientPath.addClip()
    context.drawLinearGradient(
      gradient,
      start: CGPoint(x: 0, y: rect.minY),
      end: CGPoint(x: 0, y: rect.maxY),
      options: [])
    context.restoreGState()
  }

  // MARK: - Interaction Handling
  @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: self)
    let chartRect = bounds.inset(
      by: UIEdgeInsets(
        top: topMargin,
        left: leftMargin,
        bottom: bottomMargin,
        right: rightMargin))

    let values = dataPoints.map { $0.timeValue }
    let minValue = values.min() ?? 0
    let maxValue = values.max() ?? 24
    let (adjustedMin, adjustedMax, _) = calculateNiceRange(min: minValue, max: maxValue)
    let valueRange = adjustedMax - adjustedMin

    // Find the closest point
    var closestDistance: CGFloat = .infinity
    var closestIndex: Int?

    for (index, point) in dataPoints.enumerated() {
      let x = chartRect.minX + chartRect.width * CGFloat(index) / CGFloat(dataPoints.count - 1)
      let normalizedValue = (point.timeValue - adjustedMin) / valueRange
      let y = chartRect.maxY - (CGFloat(normalizedValue) * chartRect.height)
      let pointLocation = CGPoint(x: x, y: y)

      let distance = hypot(location.x - pointLocation.x, location.y - pointLocation.y)
      if distance < hitTestRadius && distance < closestDistance {
        closestDistance = distance
        closestIndex = index
      }
    }

    // Update selection and value label
    if let index = closestIndex {
      selectedPointIndex = index
      updateValueLabel(for: index)
    } else {
      selectedPointIndex = nil
      valueLabel?.isHidden = true
    }
  }

  // Update the value label with the selected data point
  private func updateValueLabel(for index: Int) {
    guard let valueLabel = valueLabel else { return }
    let dataPoint = dataPoints[index]

    // Format the label text based on scope
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")

    let labelText: String
    switch currentScope {
    case .daily:
      labelText = String(
        format: "Time: %@ \nCompleted Duration: %.2fH ", dataPoint.formattedTime,
        dataPoint.timeValue)
    case .weekly:
      formatter.dateFormat = "EEE"
      let dayStr = formatter.string(from: dataPoint.date)
      labelText = String(
        format: "Day: %@ \nCompleted Duration: %.2fH ", dayStr, dataPoint.timeValue)
    case .monthly:
      formatter.dateFormat = "d MMM"
      let dateStr = formatter.string(from: dataPoint.date)
      labelText = String(
        format: "Date: %@ \nCompleted Duration: %.2fH ", dateStr, dataPoint.timeValue)
    case .yearly:
      formatter.dateFormat = "MMM"
      let monthStr = formatter.string(from: dataPoint.date)
      labelText = String(
        format: "Date: %@ \nCompleted Duration: %.2fH ", monthStr, dataPoint.timeValue)
    }

    valueLabel.text = labelText

    // Add padding for the label
    let padding: CGFloat = 8
    valueLabel.sizeToFit()
    valueLabel.frame.size.width += padding * 2
    valueLabel.frame.size.height += padding

    let chartRect = bounds.inset(
      by: UIEdgeInsets(
        top: topMargin,
        left: leftMargin,
        bottom: bottomMargin,
        right: rightMargin
      )
    )

    // Calculate x position
    let x = chartRect.minX + chartRect.width * CGFloat(index) / CGFloat(dataPoints.count - 1)

    // Calculate y position using the same scaling as in drawLineAndPoints
    let values = dataPoints.map { $0.timeValue }
    let minValue = values.min() ?? 0
    let maxValue = values.max() ?? 24
    let (adjustedMin, adjustedMax, _) = calculateNiceRange(min: minValue, max: maxValue)
    let valueRange = adjustedMax - adjustedMin

    let normalizedValue = (dataPoint.timeValue - adjustedMin) / valueRange
    let y = chartRect.maxY - (CGFloat(normalizedValue) * chartRect.height)

    // Calculate label position
    var labelX = x - valueLabel.bounds.width / 2
    let labelY = y - valueLabel.bounds.height - 10  // 10 points above the dot

    // Adjust horizontal position if label would overflow screen edges
    let minX = leftMargin
    let maxX = bounds.width - rightMargin - valueLabel.bounds.width
    labelX = max(minX, min(maxX, labelX))

    valueLabel.frame = CGRect(
      x: labelX,
      y: labelY,
      width: valueLabel.bounds.width,
      height: valueLabel.bounds.height
    )
    valueLabel.isHidden = false
  }

  // MARK: - Public Methods
  func updateDataPoints(_ dataPoints: [DataPoint], scope: TimeScope = .daily) {
    // Check for insufficient data points based on scope
    let insufficientData =
      (scope == .weekly && dataPoints.count < 2) || (scope == .daily && dataPoints.count < 2)

    if insufficientData {
      self.dataPoints = []
      self.currentScope = scope
      selectedPointIndex = nil
      valueLabel?.isHidden = true

      // Set appropriate message based on scope
      let minPoints = scope == .weekly ? "2" : "2"
      emptyLabel.text = "Not enough data - need at least \(minPoints) data points"
      emptyLabel.isHidden = false
      setNeedsDisplay()
      return
    }

    self.dataPoints = dataPoints.sorted { $0.date < $1.date }
    self.currentScope = scope
    selectedPointIndex = nil
    valueLabel?.isHidden = true
    emptyLabel.isHidden = !dataPoints.isEmpty

    DispatchQueue.main.async {
      self.setNeedsDisplay()
    }
  }

  // Add a method to format values based on time range
  private func formatValue(_ timeValue: Double) -> String {
    if timeValue >= 24 {
      return String(format: "%.1f h", timeValue)
    } else {
      let hours = Int(timeValue)
      let minutes = Int((timeValue - Double(hours)) * 60)
      return String(format: "%02d:%02d", hours, minutes)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setNeedsDisplay()
  }
}
