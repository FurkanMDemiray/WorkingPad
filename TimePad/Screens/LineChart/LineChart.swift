//
//  LineChart.swift
//  TimePad
//
//  Created by Melik Demiray on 10.11.2024.
//

import UIKit

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

final class LineChart: UIView {
    // MARK: - Properties
    private var dataPoints: [DataPoint] = []
    private var selectedPointIndex: Int?
    private var valueLabel: UILabel?

    // Customization
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

    // Layout
    private let topMargin: CGFloat = 40
    private let bottomMargin: CGFloat = 60
    private let leftMargin: CGFloat = 40
    private let rightMargin: CGFloat = 20
    private let pointRadius: CGFloat = 4
    private let numberOfHorizontalLines = 5
    private let labelAngle: CGFloat = -45 * .pi / 180
    private let hitTestRadius: CGFloat = 20

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizers()
        setupValueLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGestureRecognizers()
        setupValueLabel()
    }

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
        valueLabel?.layer.cornerRadius = 4
        valueLabel?.layer.masksToBounds = true
        valueLabel?.isHidden = true
        if let valueLabel = valueLabel {
            addSubview(valueLabel)
        }
    }

    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard dataPoints.count > 1 else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let chartRect = CGRect(x: rect.minX + leftMargin,
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
        formatter.dateFormat = "HH:mm"
        let xStep = rect.width / CGFloat(dataPoints.count - 1)

        for (index, point) in dataPoints.enumerated() {
            let x = (rect.minX + CGFloat(index) * xStep) - 22
            let timeString = formatter.string(from: point.date)

            let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 10),
                    .foregroundColor: textColor
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
                timeString.draw(at: CGPoint(x: 0, y: 6), withAttributes: attributes)
                context.restoreGState()
            }
        }
    }

    private func drawValueLabels(in rect: CGRect) {
        let maxValue = dataPoints.map { $0.timeValue }.max() ?? 24
        let yStep = rect.height / CGFloat(numberOfHorizontalLines - 1)
        let valueStep = maxValue / Double(numberOfHorizontalLines - 1)

        for i in 0...numberOfHorizontalLines - 1 {
            let y = rect.minY + CGFloat(i) * yStep
            let value = maxValue - Double(i) * valueStep
            let valueString = String(format: "%.1f", value)

            let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 10),
                    .foregroundColor: textColor
            ]

            let size = valueString.size(withAttributes: attributes)
            let labelPoint = CGPoint(x: rect.minX - size.width - 5,
                y: y - size.height / 2)

            valueString.draw(at: labelPoint, withAttributes: attributes)
        }
    }

    private func drawLineAndPoints(in rect: CGRect) {
        let maxYValue = dataPoints.map { $0.timeValue }.max() ?? 24
        let linePath = UIBezierPath()
        var points: [CGPoint] = []

        // Create points and line path
        for (index, data) in dataPoints.enumerated() {
            let x = rect.minX + rect.width * CGFloat(index) / CGFloat(dataPoints.count - 1)
            let y = rect.maxY - (CGFloat(data.timeValue) / CGFloat(maxYValue)) * rect.height
            let point = CGPoint(x: x, y: y)
            points.append(point)

            if index == 0 {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }

            // Draw highlighted point if selected
            if index == selectedPointIndex {
                let highlightPath = UIBezierPath(arcCenter: point,
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
            let pointPath = UIBezierPath(arcCenter: point,
                radius: pointRadius,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: true)
            lineColor.setFill()
            pointPath.fill()

            let innerPointPath = UIBezierPath(arcCenter: point,
                radius: pointRadius - 2,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: true)
            pointColor.setFill()
            innerPointPath.fill()
        }
    }

    private func drawGradient(in rect: CGRect, context: CGContext) {
        // Create gradient path
        let gradientPath = UIBezierPath()
        var points: [CGPoint] = []
        let maxYValue = dataPoints.map { $0.timeValue }.max() ?? 24

        for (index, data) in dataPoints.enumerated() {
            let x = rect.minX + rect.width * CGFloat(index) / CGFloat(dataPoints.count - 1)
            let y = rect.maxY - (CGFloat(data.timeValue) / CGFloat(maxYValue)) * rect.height
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
        let colors = [lineColor.withAlphaComponent(0.3).cgColor,
            lineColor.withAlphaComponent(0.0).cgColor]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: [0.0, 1.0]) else { return }

        context.saveGState()
        gradientPath.addClip()
        context.drawLinearGradient(gradient,
            start: CGPoint(x: 0, y: rect.minY),
            end: CGPoint(x: 0, y: rect.maxY),
            options: [])
        context.restoreGState()
    }

    // MARK: - Interaction Handling
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let chartRect = bounds.inset(by: UIEdgeInsets(top: topMargin,
            left: leftMargin,
            bottom: bottomMargin,
            right: rightMargin))

        // Find the closest point
        var closestDistance: CGFloat = .infinity
        var closestIndex: Int?

        for (index, point) in dataPoints.enumerated() {
            let x = chartRect.minX + chartRect.width * CGFloat(index) / CGFloat(dataPoints.count - 1)
            let y = chartRect.maxY - (CGFloat(point.timeValue) / CGFloat(dataPoints.map { $0.timeValue }.max() ?? 24)) * chartRect.height
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

    private func updateValueLabel(for index: Int) {
        guard let valueLabel = valueLabel else { return }
        let dataPoint = dataPoints[index]
        let chartRect = bounds.inset(by: UIEdgeInsets(top: topMargin,
            left: leftMargin,
            bottom: bottomMargin,
            right: rightMargin))

        let x = chartRect.minX + chartRect.width * CGFloat(index) / CGFloat(dataPoints.count - 1)
        let y = chartRect.maxY - (CGFloat(dataPoint.timeValue) / CGFloat(dataPoints.map { $0.timeValue }.max() ?? 24)) * chartRect.height

        valueLabel.text = " \(dataPoint.formattedTime) "
        valueLabel.sizeToFit()
        valueLabel.frame = CGRect(x: x - valueLabel.bounds.width / 2,
            y: y - valueLabel.bounds.height - 10,
            width: valueLabel.bounds.width,
            height: valueLabel.bounds.height)
        valueLabel.isHidden = false
    }

    // MARK: - Public Methods
    func updateDataPoints(_ dataPoints: [DataPoint]) {
        self.dataPoints = dataPoints
        selectedPointIndex = nil
        valueLabel?.isHidden = true
        setNeedsDisplay()
    }
}
