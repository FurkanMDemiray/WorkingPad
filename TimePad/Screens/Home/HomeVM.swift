//
//  HomeVM.swift
//  TimePad
//
//  Created by Melik Demiray on 27.09.2024.
//

import Foundation

protocol HomeVMProtocol {
    var delegate: HomeVMDelegate? { get set }
    var getWorkModels: [WorkModel] { get set }
    var getLastWork: LastWorkModel { get }
    var getLastWorkTime: String { get }
    var getFinishString: String { get }

    func didFetchWorkModels()
    func deleteWordModel(at index: Int)
    func didFetchLastWork()
}

protocol HomeVMDelegate: AnyObject {
    func updateTableView()
    func showEmptyView()
    func hideEmptyView()
    func updateTimerCard()
}

final class HomeVM {

    weak var delegate: HomeVMDelegate?
    private let coreDataManager = CoreDataManager.shared
    private var workModels: [WorkModel] = []
    private var lastWork: LastWorkModel?
    private var isFinished = false

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
        workModels.isEmpty ? delegate?.showEmptyView() : delegate?.hideEmptyView()
        workModels.sort(by: { $0.date!.compare($1.date!) == .orderedDescending })
        delegate?.updateTableView()
    }
}

extension HomeVM: HomeVMProtocol {

    //MARK: - Functions
    func didFetchLastWork() {
        lastWork = coreDataManager.fetchLastWork().map { LastWorkModel(title: $0.title, hour: Int($0.hour), minute: Int($0.minute), seconds: Int($0.seconds), type: $0.type) }
        delegate?.updateTimerCard()

        if lastWork?.hour == 0 && lastWork?.minute == 0 && lastWork?.seconds == 0 {
            isFinished = true
        } else {
            isFinished = false
        }
    }

    func didFetchWorkModels() {
        fetchWorkModels()
    }

    func deleteWordModel(at index: Int) {
        let workModel = workModels[index] // Sıralanmış listeden doğru modeli seç
        guard let work = coreDataManager.fetchWorks().first(where: { $0.id == workModel.id }) else {
            print("Work not found in CoreData")
            return
        }
        coreDataManager.deleteWork(work: work)
        coreDataManager.saveContext()
        fetchWorkModels()
    }

    //MARK: Getters
    var getLastWorkTime: String {
        let hour = getLastWork.hour ?? 0
        let minute = getLastWork.minute ?? 0
        let seconds = getLastWork.seconds ?? 0
        return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
    }

    var getWorkModels: [WorkModel] {
        get {
            workModels
        }
        set {
            workModels = newValue
        }
    }

    var getLastWork: LastWorkModel {
        lastWork ?? LastWorkModel(title: "No last job in line", hour: 0, minute: 0, seconds: 0, type: "")
    }

    var getFinishString: String {
        isFinished ? "Last job is finished" : ""
    }

}
