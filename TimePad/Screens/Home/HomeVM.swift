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

    func didFetchWorkModels()
    func deleteWordModel(at index: Int)
}

protocol HomeVMDelegate: AnyObject {
    func updateTablaView()
}

final class HomeVM {

    weak var delegate: HomeVMDelegate?
    private let coreDataManager = CoreDataManager.shared
    private var workModels: [WorkModel] = []
    private var lastWork: WorkModel?

    private func fetchWorkModels() {
        workModels = coreDataManager.fetchWorks().map { WorkModel(id: $0.id, title: $0.title, hour: Int($0.hour), minute: Int($0.minute), seconds: Int($0.seconds), firstHour: Int($0.firstHour), firstMinute: Int($0.firstMinute), type: $0.type) }
        delegate?.updateTablaView()
    }
}

extension HomeVM: HomeVMProtocol {

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
