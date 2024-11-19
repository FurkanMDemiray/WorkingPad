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
    var getSelectedType: String? { get }

    func fetchWorkModels()
    func filterData(for scope: TimeScope) -> [DataPoint]
    func calculateTotalDurations(for scope: TimeScope)

}

protocol GraphDetailVMDelegate: AnyObject {
    func updateData(with data: [DataPoint])
    func updateChart(for scope: TimeScope)
    func updateCollectionView()
    func updateColumnChart(with durations: [Int]) // Make sure this is included
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
            if type == Constants.totalTime {
                // Show column chart for total time
                filteredModels = workModels
                calculateTotalDurations()
            } else if type == Constants.all {
                filteredModels = workModels
            } else {
                filteredModels = workModels.filter { $0.type == type }
            }
        } else {
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

    var getSelectedType: String? {
        selectedType
    }

    func calculateTotalDurations(for scope: TimeScope = .daily) {
        let types = [Constants.work, Constants.workout, Constants.reading, Constants.coding]
        var durations = [0, 0, 0, 0]
        let calendar = Calendar.current
        let now = Date()

        print("Calculating durations for scope: \(scope)")

        for (index, type) in types.enumerated() {
            let typeModels = workModels.filter { $0.type == type }

            // Filter models based on scope
            let filteredModels = typeModels.filter { model in
                guard let date = model.date else { return false }

                switch scope {
                case .daily:
                    return calendar.isDate(date, inSameDayAs: now)
                case .weekly:
                    let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
                    return date >= weekAgo && date <= now
                case .monthly:
                    let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
                    return date >= monthAgo && date <= now
                case .yearly:
                    let yearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
                    return date >= yearAgo && date <= now
                }
            }

            // Calculate total duration for this type
            let totalSeconds = filteredModels.reduce(0) { total, model in
                let hours = Int(model.firstHour ?? 0)
                let minutes = Int(model.firstMinute ?? 0)
                return total + (hours * 3600 + minutes * 60)
            }

            durations[index] = totalSeconds
            print("Duration for \(type): \(totalSeconds) seconds")
            delegate?.updateColumnChart(with: durations)
        }
        delegate?.updateColumnChart(with: durations)
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
