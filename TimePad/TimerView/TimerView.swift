//
//  TimerView.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import Foundation
import UIKit

final class TimerView: UIView {

    private var timerLabel: UILabel!
    private var shapeLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    private var timer: Timer?
    private var remainingTime: TimeInterval
    private var totalTime: TimeInterval

    init(frame: CGRect, totalTime: TimeInterval) {
        self.totalTime = totalTime
        self.remainingTime = totalTime
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // View'in ortası
        let circularPathCenter = CGPoint(x: bounds.midX, y: bounds.midY)

        // Track layer (arkaplan çemberi)
        trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: circularPathCenter, radius: frame.size.width / 2.5, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        // Animasyonlu çember (progress bar)
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 1
        layer.addSublayer(shapeLayer)

        // Zamanı gösteren label
        timerLabel = UILabel()
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        timerLabel.text = "\(Int(remainingTime))"
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timerLabel)

        // Label'i merkeze yerleştirme
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

        // Animasyonu başlat
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = totalTime
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }

    @objc private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            timerLabel.text = "\(Int(remainingTime))"
        } else {
            timer?.invalidate()
        }
    }
}
