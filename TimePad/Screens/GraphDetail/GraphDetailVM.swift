//
//  GraphDetailVM.swift
//  TimePad
//
//  Created by Melik Demiray on 8.11.2024.
//

import Foundation

protocol GraphDetailVMProtocol {
  var delegate: GraphDetailVMDelegate? { get set }
  var getWorkModels: [WorkModel] { get }
  var getDataPoints: [DataPoint] { get }

  func fetchWorkModels()
  func filterData(for scope: TimeScope) -> [DataPoint]

}

protocol GraphDetailVMDelegate: AnyObject {
  func updateCollectionView()
  func updateChart(for scope: TimeScope)
  func updateData(with dataPoints: [DataPoint])

}

final class GraphDetailVM {

  weak var delegate: GraphDetailVMDelegate?
  private let coreDataManager = CoreDataManager.shared
  private var workModels: [WorkModel] = []
  private var dataPoints: [DataPoint] = []

  private func setupDataPoints() {
    //dataPoints = workModels.map { DataPoint(date: $0.date!, hour: $0.firstHour ?? 0, minute: $0.firstMinute ?? 0) }

    // mock data
    dataPoints = [
      DataPoint(date: Date().addingTimeInterval(3600), hour: 10, minute: 30),
      DataPoint(date: Date().addingTimeInterval(7200), hour: 12, minute: 15),
      DataPoint(date: Date().addingTimeInterval(-5555), hour: 7, minute: 0),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 8, minute: 15),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 9, minute: 30),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 10, minute: 45),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 11, minute: 0),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 12, minute: 15),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 13, minute: 30),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 14, minute: 45),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 15, minute: 0),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 16, minute: 15),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 17, minute: 30),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 18, minute: 45),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 19, minute: 0),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 20, minute: 15),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 21, minute: 30),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 22, minute: 45),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 23, minute: 0),
      DataPoint(date: Date().addingTimeInterval(-86400), hour: 24, minute: 0),
    ]
    delegate?.updateData(with: dataPoints)
  }
}

extension GraphDetailVM: GraphDetailVMProtocol {
  var getDataPoints: [DataPoint] {
    dataPoints
  }

  var getWorkModels: [WorkModel] {
    workModels
  }

  func fetchWorkModels() {
    workModels = coreDataManager.getWorkModels()
    guard !workModels.isEmpty else { return }
    self.workModels = workModels.sorted { $0.date! < $1.date! }
    setupDataPoints()
  }

  func filterData(for scope: TimeScope) -> [DataPoint] {
    let calendar = Calendar.current
    let now = Date()
    
    let filtered: [DataPoint]
    
    switch scope {
    case .daily:
        filtered = dataPoints.filter { calendar.isDate($0.date, inSameDayAs: now) }
    case .weekly:
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            return []
        }
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
        filtered = dataPoints.filter { $0.date >= weekStart && $0.date < weekEnd }
    case .monthly:
        filtered = dataPoints.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
    case .yearly:
        filtered = dataPoints.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .year) }
    }
    
    // Debug print
    print("Filtering for scope: \(scope), found \(filtered.count) points")
    return filtered.sorted { $0.date < $1.date }
  }

}
