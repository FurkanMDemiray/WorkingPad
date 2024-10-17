//
//  TimerVC.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import UIKit

final class TimerVC: UIViewController {

    private var timerView: TimerView!
    var workModel: WorkModel!
    static let pauseButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        addTimer()
        addButtons()
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "060417")
    }

    private func addTimer() {
        guard let hour = workModel.hour, let minute = workModel.minute else { return }

        timerView = TimerView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 300,
                height: 300
            ),
            hours: hour,
            minutes: minute,
            seconds: 0
        )

        view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timerView.widthAnchor.constraint(equalToConstant: 300),
            timerView.heightAnchor.constraint(equalToConstant: 300),
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height / 4)
            ])

        timerView.startTimer()
    }

    private func addButtons() {

        TimerVC.pauseButton.setTitle("Pause", for: .normal)
        TimerVC.pauseButton.setTitleColor(.white, for: .normal)
        TimerVC.pauseButton.backgroundColor = UIColor.hexStringToUIColor(hex: "2de092")
        TimerVC.pauseButton.layer.cornerRadius = 32
        TimerVC.pauseButton.layer.masksToBounds = true
        TimerVC.pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        view.addSubview(TimerVC.pauseButton)

        let quitButton = UIButton(type: .system)
        quitButton.setTitle("Reset", for: .normal)
        quitButton.setTitleColor(.white, for: .normal)
        quitButton.backgroundColor = UIColor.hexStringToUIColor(hex: "3d4aba")
        quitButton.layer.cornerRadius = 32
        quitButton.layer.masksToBounds = true
        quitButton.addTarget(self, action: #selector(quitTapped), for: .touchUpInside)
        view.addSubview(quitButton)

        TimerVC.pauseButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            TimerVC.pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -64),
            TimerVC.pauseButton.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 32),
            TimerVC.pauseButton.widthAnchor.constraint(equalToConstant: 64),
            TimerVC.pauseButton.heightAnchor.constraint(equalToConstant: 64),

            quitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 64),
            quitButton.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 32),
            quitButton.widthAnchor.constraint(equalToConstant: 64),
            quitButton.heightAnchor.constraint(equalToConstant: 64)
            ])
    }

    @objc private func pauseTapped() {
        timerView.pauseTimer()
    }

    @objc private func quitTapped() {
        timerView.quitTimer()
    }
}


