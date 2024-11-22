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

  //MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
    setUpCalendar()
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
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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

}

//MARK: - FSCalendar Delegate & DataSource
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource {

  func calendar(
    _ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition
  ) {
    print("Selected date: \(date)")
  }

}
