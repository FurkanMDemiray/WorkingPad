//
//  HomeVM.swift
//  TimePad
//
//  Created by Melik Demiray on 27.09.2024.
//

import Foundation

protocol HomeVMProtocol {
    var delegate: HomeVMDelegate? { get set }
    var getWorkModels: [WorkModel] { get }
    var getLastWork: LastWorkModel { get }
    var getLastWorkTime: String { get }

    func didFetchWorkModels()
    func deleteWordModel(at index: Int)
    func didFetchLastWork()
}

protocol HomeVMDelegate: AnyObject {
    func updateTableView()
    func showEmptyView()
    func hideEmptyView()
}

final class HomeVM {

    weak var delegate: HomeVMDelegate?
    private let coreDataManager = CoreDataManager.shared
    private var workModels: [WorkModel] = []
    private var lastWork: LastWorkModel?

    private func fetchWorkModels() {
        workModels = coreDataManager.fetchWorks().map { WorkModel(id: $0.id, title: $0.title, hour: Int($0.hour), minute: Int($0.minute), seconds: Int($0.seconds), firstHour: Int($0.firstHour), firstMinute: Int($0.firstMinute), type: $0.type) }
        workModels.isEmpty ? delegate?.showEmptyView() : delegate?.hideEmptyView()
        delegate?.updateTableView()
    }
}

extension HomeVM: HomeVMProtocol {
    var getLastWorkTime: String {
        let hour = getLastWork.hour ?? 0
        let minute = getLastWork.minute ?? 0
        let seconds = getLastWork.seconds ?? 0
        return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
    }

    var getLastWork: LastWorkModel {
        lastWork ?? LastWorkModel(title: "No last job in line", hour: 0, minute: 0, seconds: 0, type: "")
    }

    func didFetchLastWork() {
        lastWork = coreDataManager.fetchLastWork().map { LastWorkModel(title: $0.title, hour: Int($0.hour), minute: Int($0.minute), seconds: Int($0.seconds), type: $0.type) }
    }

    func deleteWordModel(at index: Int) {
        let work = coreDataManager.fetchWorks()[index]
        coreDataManager.context.delete(work)
        coreDataManager.saveContext()
        fetchWorkModels()
    }

    var getWorkModels: [WorkModel] {
        workModels
    }

    func didFetchWorkModels() {
        fetchWorkModels()
    }
}
