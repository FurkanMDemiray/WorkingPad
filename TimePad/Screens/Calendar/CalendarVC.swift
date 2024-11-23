//
//  CalendarVC.swift
//  TimePad
//
//  Created by Melik Demiray on 20.11.2024.
//

import FSCalendar
import UIKit

//MARK: - CalendarVC
final class CalendarVC: UIViewController {

  //MARK: - Properties
  fileprivate weak var calendar: FSCalendar!
  private var tutorialView: TutorialView?

  //MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
    setUpCalendar()

    if !UserDefaults.standard.bool(forKey: "hasSeenCalendarTutorial") {
      showTutorial()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setCalendarSelectedsDate()
  }

  //MARK: - UI Elements
  lazy var label: UILabel = {
    let label = UILabel()
    label.text = "My Task History"
    label.textColor = .white
    label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    return label
  }()

  //MARK: - Private Methods
  private func configureCalendar() {
    let calendar = FSCalendar()
    calendar.delegate = self
    calendar.dataSource = self
    calendar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(calendar)
    self.calendar = calendar
    calendar.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
    calendar.appearance.headerTitleColor = UIColor.hexStringToUIColor(hex: Colors.orange)
    calendar.appearance.weekdayTextColor = UIColor.hexStringToUIColor(hex: Colors.red)
    calendar.appearance.todayColor = .clear
    calendar.appearance.selectionColor = .systemGreen
    calendar.appearance.titleDefaultColor = .white
    calendar.appearance.eventDefaultColor = .systemGreen
    calendar.allowsMultipleSelection = true
  }

  private func configureCalendarConstraints() {
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),

      calendar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
      calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      calendar.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
    ])
  }

  private func setCalendarSelectedsDate() {
    calendar.allowsSelection = true
    let tasks = CoreDataManager.shared.fetchWorks()
    let filteredTasks = tasks.filter { $0.hour == 0 && $0.minute == 0 && $0.seconds == 0 }
    filteredTasks.forEach { task in
      calendar.select(task.date)
    }
    calendar.allowsSelection = false
  }

  private func setUpCalendar() {
    configureCalendar()
    configureCalendarConstraints()
  }

  private func showTutorial() {
    tutorialView = TutorialView(frame: view.bounds)
    guard let tutorialView = tutorialView else { return }

    view.addSubview(tutorialView)
    tutorialView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      tutorialView.topAnchor.constraint(equalTo: view.topAnchor),
      tutorialView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tutorialView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tutorialView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    let steps: [(title: String, description: String, frame: CGRect)] = [
      (
        title: "Welcome to Calendar",
        description:
          "Track your completed tasks and view your productivity history in this beautiful calendar view.",
        frame: label.frame.insetBy(dx: -100, dy: -200)
      ),
      (
        title: "Task Completion Dates",
        description:
          "Green dots indicate days where you've completed tasks. These are automatically marked when you finish a task.",
        frame: calendar.frame.insetBy(dx: -100, dy: -250)
      ),
      (
        title: "Monthly Overview",
        description:
          "Swipe left or right to view different months and track your progress over time.",
        frame: calendar.frame.insetBy(dx: -100, dy: -400)
      ),
    ]

    tutorialView.startTutorial(steps: steps) { [weak self] in
      UserDefaults.standard.set(true, forKey: "hasSeenCalendarTutorial")
      self?.tutorialView?.removeFromSuperview()
      self?.tutorialView = nil
    }
  }

}

//MARK: - FSCalendar Delegate & DataSource
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource {

  func calendar(
    _ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition
  ) {
    print("Selected date: \(date)")
  }

}
