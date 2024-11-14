//
//  StopwatchVC.swift
//  TimePad
//
//  Created by Melik Demiray on 13.11.2024.
//

import UIKit

final class StopwatchVC: UIViewController {

  // MARK: - Properties
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "00:00:00"
    label.font = .monospacedDigitSystemFont(ofSize: 60, weight: .medium)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()

  private let startStopButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Start", for: .normal)
    button.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.green)
    button.layer.cornerRadius = 35
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
    return button
  }()

  private let resetButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Reset", for: .normal)
    button.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.red)
    button.layer.cornerRadius = 35
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
    button.isHidden = true
    return button
  }()

  private var timer: Timer?
  private var isRunning = false
  private var elapsedTime: TimeInterval = 0

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupActions()
  }

  // MARK: - UI Setup
  private func setupUI() {
    view.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)

    view.addSubview(timeLabel)
    view.addSubview(startStopButton)
    view.addSubview(resetButton)

    NSLayoutConstraint.activate([
      timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
      timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

      startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      startStopButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 50),
      startStopButton.widthAnchor.constraint(equalToConstant: 200),
      startStopButton.heightAnchor.constraint(equalToConstant: 70),

      resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      resetButton.topAnchor.constraint(equalTo: startStopButton.bottomAnchor, constant: 20),
      resetButton.widthAnchor.constraint(equalToConstant: 200),
      resetButton.heightAnchor.constraint(equalToConstant: 70),
    ])
  }

  private func setupActions() {
    startStopButton.addTarget(self, action: #selector(startStopTapped), for: .touchUpInside)
    resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
  }

  // MARK: - Actions
  @objc private func startStopTapped() {
    if isRunning {
      stopTimer()
      startStopButton.backgroundColor = .systemGreen
      startStopButton.setTitle("Start", for: .normal)
    } else {
      startTimer()
      startStopButton.backgroundColor = .systemOrange
      startStopButton.setTitle("Stop", for: .normal)
    }
    isRunning.toggle()
    resetButton.isHidden = false
  }

  @objc private func resetTapped() {
    stopTimer()
    elapsedTime = 0
    updateDisplay()
    startStopButton.backgroundColor = .systemGreen
    startStopButton.setTitle("Start", for: .normal)
    resetButton.isHidden = true
    isRunning = false
  }

  // MARK: - Timer Functions
  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
      self?.elapsedTime += 0.01
      self?.updateDisplay()
    }
  }

  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }

  private func updateDisplay() {
    let hours = Int(elapsedTime) / 3600
    let minutes = Int(elapsedTime) / 60 % 60
    let seconds = Int(elapsedTime) % 60
    let centiseconds = Int((elapsedTime * 100).truncatingRemainder(dividingBy: 100))

    timeLabel.text = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
  }

}
