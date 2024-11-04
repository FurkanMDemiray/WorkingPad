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
    private let pauseButton = UIButton(type: .system)
    private let coreDataManager = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        addTimer()
        addButtons()
        timerView.delegate = self
        view.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timerView.setLastWorkModel()
        updateWorkModel(id: workModel.id!, hour: timerView.lastHour!, minute: timerView.lastMinute!, seconds: timerView.lastSeconds!)
        createOrUpdateLastWorkModel()
    }

//MARK: Coredata
    private func updateWorkModel(id: String, hour: Int, minute: Int, seconds: Int) {
        coreDataManager.updateWork(by: id, newTitle: workModel.title!, newHour: hour, newMinute: minute, newSeconds: seconds, newType: workModel.type!)
    }

    private func createOrUpdateLastWorkModel() {
        coreDataManager.createOrUpdateLastWork(title: workModel.title!, hour: timerView.lastHour!, minute: timerView.lastMinute!, seconds: timerView.lastSeconds!, type: workModel.type!)
    }

//MARK: UI
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
            seconds: workModel.seconds ?? 0
        )

        view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timerView.widthAnchor.constraint(equalToConstant: 300),
            timerView.heightAnchor.constraint(equalToConstant: 300),
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height / 4)
            ])
        DispatchQueue.main.async {
            self.timerView.startTimer()
        }
    }

    private func addButtons() {
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.backgroundColor = UIColor.hexStringToUIColor(hex: "2de092")
        pauseButton.layer.cornerRadius = 32
        pauseButton.layer.masksToBounds = true
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        view.addSubview(pauseButton)

        let quitButton = UIButton(type: .system)
        quitButton.setTitle("Reset", for: .normal)
        quitButton.setTitleColor(.white, for: .normal)
        quitButton.backgroundColor = UIColor.hexStringToUIColor(hex: "3d4aba")
        quitButton.layer.cornerRadius = 32
        quitButton.layer.masksToBounds = true
        quitButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        view.addSubview(quitButton)

        let titleLabel = UILabel()
        titleLabel.text = workModel.title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

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
            quitButton.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: quitButton.bottomAnchor, constant: 64)

            ])
    }

//MARK: Actions
    @objc private func pauseTapped() {
        timerView.toggleTimer()
    }

    @objc private func resetTapped() {
        timerView.resetTimer(firstHour: workModel.firstHour!, firstMinute: workModel.firstMinute!)
    }

    private func showCompletionAlert() {
        let alert = UIAlertController(
            title: "Timer Completed!",
            message: "Great job! You've completed your task.",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Dismiss and return to home
            self?.navigationController?.popViewController(animated: true)
        }

        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

//MARK: TimerViewDelegate
extension TimerVC: TimerViewDelegate {
    func pauseButtonTapped() {
        pauseButton.setTitle("Resume", for: .normal)
    }

    func resumeButtonTapped() {
        pauseButton.setTitle("Pause", for: .normal)
    }

    func timerDidComplete() {
        showCompletionAlert()
    }

}
