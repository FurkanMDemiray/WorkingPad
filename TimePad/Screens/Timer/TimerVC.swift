//
//  TimerVC.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import UIKit

final class TimerVC: UIViewController {

    private var timerView: TimerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addTimer()
        addButtons()
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "060417")
    }

    private func addTimer() {
        timerView = TimerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), hours: 2, minutes: 5, seconds: 10)

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

        let pauseButton = UIButton(type: .system)
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.backgroundColor = UIColor.hexStringToUIColor(hex: "2de092")
        pauseButton.layer.cornerRadius = 32
        pauseButton.layer.masksToBounds = true
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        view.addSubview(pauseButton)

        let quitButton = UIButton(type: .system)
        quitButton.setTitle("Quit", for: .normal)
        quitButton.setTitleColor(.white, for: .normal)
        quitButton.backgroundColor = UIColor.hexStringToUIColor(hex: "3d4aba")
        quitButton.layer.cornerRadius = 32
        quitButton.layer.masksToBounds = true
        quitButton.addTarget(self, action: #selector(quitTapped), for: .touchUpInside)
        view.addSubview(quitButton)

        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -64),
            pauseButton.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 32),
            pauseButton.widthAnchor.constraint(equalToConstant: 64),
            pauseButton.heightAnchor.constraint(equalToConstant: 64),

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


