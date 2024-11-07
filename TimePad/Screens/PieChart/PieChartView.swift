//
//  PieChartView.swift
//  TimePad
//
//  Created by Melik Demiray on 7.11.2024.
//

import UIKit

class PieChartView: UIView {

    private var segments: [Segment] = []

    struct Segment {
        let color: UIColor
        let value: CGFloat
    }

    // Configure the chart with an array of segments
    func configure(segments: [Segment]) {
        self.segments = segments
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        // Calculate the total value of all segments
        let total = segments.reduce(0) { $0 + $1.value }

        // Set up start angle
        var startAngle = -CGFloat.pi / 2

        for segment in segments {
            // Calculate end angle for this segment
            let endAngle = startAngle + 2 * .pi * (segment.value / total)

            // Create a path for this segment
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: min(bounds.width, bounds.height) / 2,
                        startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()

            // Create a shape layer
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = segment.color.cgColor

            // Add the shape layer to the view
            layer.addSublayer(shapeLayer)

            // Update start angle for the next segment
            startAngle = endAngle
        }
    }
}
