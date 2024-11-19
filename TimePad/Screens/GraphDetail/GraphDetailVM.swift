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
  var selectedType: String?

  private func setupDataPoints() {
    // Convert WorkModels to DataPoints
    var realDataPoints: [DataPoint] = []

    // Filter workModels based on selectedType
    let filteredModels: [WorkModel]
    if let type = selectedType {
      if type == Constants.all || type == Constants.totalTime {
        filteredModels = workModels
      } else {
        filteredModels = workModels.filter { $0.type == type }
      }
    } else {
      // If no type selected (Total Time), return empty array
      filteredModels = []
    }

    for workModel in filteredModels {
      guard let date = workModel.date,
        let hour = workModel.firstHour,
        let minute = workModel.firstMinute
      else { continue }

      realDataPoints.append(DataPoint(date: date, hour: hour, minute: minute))
    }

    dataPoints = realDataPoints.sorted { $0.date < $1.date }
    print("Setup \(dataPoints.count) real data points for type: \(selectedType ?? "none")")
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
    workModels = workModels.filter { $0.hour == 0 && $0.minute == 0 && $0.seconds == 0 }
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
      if filtered.count < 2 {
        print("Insufficient data points for daily view: \(filtered.count)")
        return []
      }

    case .weekly:
      guard
        let weekStart = calendar.date(
          from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))
      else { return [] }
      let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
      filtered = dataPoints.filter { $0.date >= weekStart && $0.date < weekEnd }

      if filtered.count < 2 {
        print("Insufficient data points for weekly view: \(filtered.count)")
        return []
      }

    case .monthly:
      filtered = dataPoints.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }
      if filtered.count < 2 {
        print("Insufficient data points for monthly view: \(filtered.count)")
        return []
      }

    case .yearly:
      filtered = dataPoints.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .year) }
      if filtered.count < 2 {
        print("Insufficient data points for yearly view: \(filtered.count)")
        return []
      }
    }

    // Debug print
    print("Filtering for scope: \(scope), found \(filtered.count) points")

    if filtered.isEmpty {
      print("No data found for scope: \(scope)")
    }

    return filtered.sorted { $0.date < $1.date }
  }

}
