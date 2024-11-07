//
//  GraphsVM.swift
//  TimePad
//
//  Created by Melik Demiray on 6.11.2024.
//

import Foundation

protocol GraphsVMProtocol {
    var delegate: GraphsVMDelegate? { get set }
    var getCellTitles: [String] { get }
    var getCellImages: [String] { get }
    var getSumOfCodingTime: String { get }
    var getSumOfReadingTime: String { get }
    var getSumOfWorkingTime: String { get }
    var getSumOfTrainingTime: String { get }
    var getSumOfCompletedTasks: String { get }
    var getTotalDuration: String { get }
    var getSumsOfTimes: (coding: String, reading: String, working: String, training: String) { get }

    func didFetchWorkModels()
}

protocol GraphsVMDelegate: AnyObject {
    func createPieChart(with segment: [PieChartView.Segment])
}

final class GraphsVM {

    weak var delegate: GraphsVMDelegate?
    private let coreDataManager = CoreDataManager.shared
    private var workModels: [WorkModel] = []
    private var cellTitles: [String] = ["Coding", "Reading", "Working", "Training", "Completed", "Total Time"]
    private var cellImages: [String] = ["coding", "reading", "work", "workout", "completed", "duration"]
    private var totalTimes: [String: (hours: Int, minutes: Int, seconds: Int)] = [:]

    func didFetchWorkModels() {
        fetchWorkModels()
    }

    private func fetchWorkModels() {
        let allWorks = coreDataManager.fetchWorks()

        workModels = allWorks
            .map { WorkModel(
            id: $0.id,
            title: $0.title,
            hour: Int($0.hour),
            minute: Int($0.minute),
            seconds: Int($0.seconds),
            firstHour: Int($0.firstHour),
            firstMinute: Int($0.firstMinute),
            type: $0.type,
            date: $0.date)
        }
            .filter { model in
            // Include only if at least one time value is not zero
            return model.hour != 0 || model.minute != 0 || model.seconds != 0
        }
        //print("WorkModels: \(workModels)")
        totalTimes = calculateTotalTime(for: workModels)
        delegate?.createPieChart(with: setUpSegments())
    }

    private func calculateTotalTime(for works: [WorkModel]) -> [String: (hours: Int, minutes: Int, seconds: Int)] {
        var totalTimes: [String: (hours: Int, minutes: Int, seconds: Int)] = [
            Constants.coding: (0, 0, 0),
            Constants.reading: (0, 0, 0),
            Constants.work: (0, 0, 0),
            Constants.workout: (0, 0, 0)
        ]

        for work in works {
            guard let type = work.type,
                let hours = work.hour,
                let minutes = work.minute,
                let seconds = work.seconds else { continue }

            if totalTimes[type] != nil {
                totalTimes[type]!.hours += hours
                totalTimes[type]!.minutes += minutes
                totalTimes[type]!.seconds += seconds

                // Saniyeleri dakikaya dönüştür
                if totalTimes[type]!.seconds >= 60 {
                    totalTimes[type]!.minutes += totalTimes[type]!.seconds / 60
                    totalTimes[type]!.seconds %= 60
                }

                // Dakikaları saate dönüştür
                if totalTimes[type]!.minutes >= 60 {
                    totalTimes[type]!.hours += totalTimes[type]!.minutes / 60
                    totalTimes[type]!.minutes %= 60
                }
            }
        }
        return totalTimes
    }

    private func setUpSegments() -> [PieChartView.Segment] {
        let segments: [PieChartView.Segment] = [
                .init(color: .hexStringToUIColor(hex: Colors.red), value: CGFloat(totalTimes[Constants.coding]!.hours * 60 + totalTimes[Constants.coding]!.minutes), label: Constants.coding),
                .init(color: .hexStringToUIColor(hex: Colors.purple), value: CGFloat(totalTimes[Constants.reading]!.hours * 60 + totalTimes[Constants.reading]!.minutes), label: Constants.reading),
                .init(color: .hexStringToUIColor(hex: Colors.green), value: CGFloat(totalTimes[Constants.work]!.hours * 60 + totalTimes[Constants.work]!.minutes), label: Constants.work),
                .init(color: .hexStringToUIColor(hex: Colors.orange), value: CGFloat(totalTimes[Constants.workout]!.hours * 60 + totalTimes[Constants.workout]!.minutes), label: Constants.workout)
        ]
        return segments
    }

}

extension GraphsVM: GraphsVMProtocol {

    var getCellImages: [String] {
        cellImages
    }

    var getCellTitles: [String] {
        cellTitles
    }

    var getSumOfCodingTime: String {
        let codingTime = totalTimes[Constants.coding]
        let codingCount = workModels.filter { $0.type == Constants.coding }.count
        return "\(codingTime!.hours)H \(codingTime!.minutes)M\nCompleted: \(codingCount)"
    }

    var getSumOfReadingTime: String {
        let readingTime = totalTimes[Constants.reading]
        let readingCount = workModels.filter { $0.type == Constants.reading }.count
        return "\(readingTime!.hours)H \(readingTime!.minutes)M\nCompleted: \(readingCount)"
    }

    var getSumOfWorkingTime: String {
        let workingTime = totalTimes[Constants.work]
        let workingCount = workModels.filter { $0.type == Constants.work }.count
        return "\(workingTime!.hours)H \(workingTime!.minutes)M\nCompleted: \(workingCount)"
    }

    var getSumOfTrainingTime: String {
        let trainingTime = totalTimes[Constants.workout]
        let trainingCount = workModels.filter { $0.type == Constants.workout }.count
        return "\(trainingTime!.hours)H \(trainingTime!.minutes)M\nCompleted: \(trainingCount)"
    }

    var getSumsOfTimes: (coding: String, reading: String, working: String, training: String) {
        (getSumOfCodingTime, getSumOfReadingTime, getSumOfWorkingTime, getSumOfTrainingTime)
    }

    var getSumOfCompletedTasks: String {
        String(workModels.count)
    }

    var getTotalDuration: String {
        let totalHours = totalTimes.reduce(0) { $0 + $1.value.hours }
        let totalMinutes = totalTimes.reduce(0) { $0 + $1.value.minutes }
        return "\(totalHours)H \(totalMinutes)M"
    }
}

