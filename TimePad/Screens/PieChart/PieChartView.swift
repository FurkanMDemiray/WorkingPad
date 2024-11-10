//
//  PieChartView.swift
//  TimePad
//
//  Created by Melik Demiray on 7.11.2024.
//

import UIKit

final class PieChartView: UIView {

    private var segments: [Segment] = []

    struct Segment {
        let color: UIColor
        let value: CGFloat
        let label: String // Label to display outside the pie chart
    }

    func configure(segments: [Segment]) {
        self.segments = segments
        layer.sublayers?.forEach { $0.removeFromSuperlayer() } // Clear any previous layers
        //addLegend() // Add legend labels outside the chart
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let total = segments.reduce(0) { $0 + $1.value }
        var startAngle = -CGFloat.pi / 2

        for segment in segments {
            let endAngle = startAngle + 2 * .pi * (segment.value / total)

            // Create the segment path
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: min(bounds.width, bounds.height) / 2,
                startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()

            // Segment layer
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = segment.color.cgColor
            layer.addSublayer(shapeLayer)

            // Calculate the percentage for the segment
            let percentage = segment.value / total * 100
            if percentage > 0 { // Only display if percentage is non-zero
                // Calculate the center of each segment for percentage placement
                let midAngle = (startAngle + endAngle) / 2
                let labelRadius = min(bounds.width, bounds.height) / 2 * 0.7 // Adjust distance of percentage from center
                let labelCenter = CGPoint(x: center.x + labelRadius * cos(midAngle),
                    y: center.y + labelRadius * sin(midAngle))

                // Create the percentage text layer
                let textLayer = CATextLayer()
                textLayer.string = "\(Int(percentage))%" // Display only percentage
                textLayer.fontSize = 14
                textLayer.alignmentMode = .center
                textLayer.foregroundColor = UIColor.black.cgColor
                textLayer.backgroundColor = UIColor.clear.cgColor
                textLayer.contentsScale = UIScreen.main.scale

                // Position the percentage label at the calculated center of the segment
                textLayer.frame = CGRect(x: labelCenter.x - 15, y: labelCenter.y - 10, width: 35, height: 20)
                layer.addSublayer(textLayer)
            }

            startAngle = endAngle
        }
    }
}
