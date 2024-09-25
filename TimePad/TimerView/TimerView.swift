//
//  TimerView.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import Foundation
import UIKit

class TimerView: UIView {

    private var timerLabel: UILabel!
    private var shapeLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    private var timer: Timer?
    private var remainingTime: TimeInterval
    private var totalTime: TimeInterval
    private var isPaused = false

    init(frame: CGRect, hours: Int, minutes: Int, seconds: Int) {
        // Toplam süreyi saniye cinsinden hesapla
        self.totalTime = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        self.remainingTime = self.totalTime
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
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
        shapeLayer.strokeColor = UIColor.hexStringToUIColor(hex: "b98ce7").cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 1
        layer.addSublayer(shapeLayer)

        // Zamanı gösteren label
        timerLabel = UILabel()
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        timerLabel.text = timeString(from: remainingTime)
        timerLabel.textColor = .white
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timerLabel)

        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    // Zamanı saat:dakika:saniye formatına çeviren fonksiyon
    private func timeString(from time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) % 3600 / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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

    func pauseTimer() {
        if !isPaused {
            timer?.invalidate() // Timer'ı durdur
            isPaused = true
        } else {
            startTimer() // Timer'ı tekrar başlat
            isPaused = false
        }
    }

    func quitTimer() {
        timer?.invalidate() // Timer'ı tamamen durdur
        remainingTime = totalTime
        timerLabel.text = timeString(from: remainingTime)
        shapeLayer.strokeEnd = 1 // Çemberi sıfırla
    }

    @objc private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            timerLabel.text = timeString(from: remainingTime) // Label'i güncelle
        } else {
            timer?.invalidate()
        }
    }
}
