//
//  TimerVC.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import UIKit

final class TimerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTimer()
    }

    private func addTimer() {
        let timerView = TimerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), totalTime: 60)

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

}
