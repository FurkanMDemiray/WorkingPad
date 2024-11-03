//
//  TimerView.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import Foundation
import UIKit

protocol TimerViewDelegate: AnyObject {
    func pauseButtonTapped()
    func resumeButtonTapped()
}

final class TimerView: UIView {

    weak var delegate: TimerViewDelegate?
    private var timerLabel: UILabel!
    private var shapeLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    private var timer: Timer?
    private var remainingTime: TimeInterval
    private var totalTime: TimeInterval
    private(set) var isPaused = false
    var lastHour: Int?
    var lastMinute: Int?
    var lastSeconds: Int?

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
        trackLayer.strokeColor = UIColor.hexStringToUIColor(hex: Colors.fillColor).cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.hexStringToUIColor(hex: Colors.fillColor).cgColor
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        // Animasyonlu çember (progress bar)
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.hexStringToUIColor(hex: Colors.lightPurple).cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.hexStringToUIColor(hex: Colors.fillColor).cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 1
        layer.addSublayer(shapeLayer)

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

    func toggleTimer() {
        if isPaused {
            resumeTimer()
        } else {
            pauseTimer()
        }
    }

    private func pauseTimer() {
        delegate?.pauseButtonTapped()
        timer?.invalidate()
        setLastWorkModel()
        isPaused = true

        // Animasyonu duraklat
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }

    private func resumeTimer() {
        delegate?.resumeButtonTapped()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isPaused = false

        // Animasyonu devam ettir
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }

    func resetTimer(firstHour: Int, firstMinute: Int) {
        timer?.invalidate()

        if firstHour == 0 && firstMinute != 0 {
            remainingTime = TimeInterval(firstMinute * 60)
        } else if firstMinute == 0 && firstHour != 0 {
            remainingTime = TimeInterval(firstHour * 3600)
        } else {
            remainingTime = TimeInterval(firstHour * 3600 + firstMinute * 60)
        }

        timerLabel.text = timeString(from: remainingTime)
        shapeLayer.removeAllAnimations()
        shapeLayer.strokeEnd = 1
        isPaused = true

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = remainingTime
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")

        // Timer'ı tekrar başlat
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func setLastWorkModel() {
        lastHour = Int(remainingTime) / 3600
        lastMinute = Int(remainingTime) % 3600 / 60
        lastSeconds = Int(remainingTime) % 60
    }

    @objc private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            timerLabel.text = timeString(from: remainingTime)
        } else {
            timer?.invalidate()
        }
    }
}
