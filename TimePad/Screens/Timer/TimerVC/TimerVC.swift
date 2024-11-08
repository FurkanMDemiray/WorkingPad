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
        guard let workModel else { return }

        timerView = TimerView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 300,
                height: 300
            ),
            model: workModel
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
        pauseButton.accessibilityIdentifier = "PauseButton"
        view.addSubview(pauseButton)

        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = UIColor.hexStringToUIColor(hex: "3d4aba")
        resetButton.layer.cornerRadius = 32
        resetButton.layer.masksToBounds = true
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        resetButton.accessibilityIdentifier = "ResetButton"
        view.addSubview(resetButton)

        let titleLabel = UILabel()
        titleLabel.text = workModel.title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -64),
            pauseButton.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 32),
            pauseButton.widthAnchor.constraint(equalToConstant: 64),
            pauseButton.heightAnchor.constraint(equalToConstant: 64),

            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 64),
            resetButton.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 32),
            resetButton.widthAnchor.constraint(equalToConstant: 64),
            resetButton.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 64)

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
