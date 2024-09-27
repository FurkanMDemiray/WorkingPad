//
//  AddWorkVM.swift
//  TimePad
//
//  Created by Melik Demiray on 26.09.2024.
//

import Foundation
import CoreData

protocol AddWorkVMProtocol {
    var delegate: AddWorkVMDelegate? { get set }
    func didSave(model: WorkModel)
    func fetchWorkModels()
}

protocol AddWorkVMDelegate: AnyObject {
    func showErrorAlert()
    func showSuccesAlert()
}

final class AddWorkVM {
    weak var delegate: AddWorkVMDelegate?
    let coreDataManager = CoreDataManager.shared


    private func saveWorkModel(model: WorkModel) {
        guard let title = model.title, !title.isEmpty else {
            delegate?.showErrorAlert()
            return
        }
        guard let hour = model.hour, let minute = model.minute else { return }
        coreDataManager.createWork(title: title, hour: hour, minute: minute, type: model.type ?? "Personal")
    }

    func fetchWorkModels() {
        let workModels = coreDataManager.fetchWorks().map { WorkModel(title: $0.title, hour: Int($0.hour), minute: Int($0.minute), type: $0.type) }
        print(workModels)
    }

}

extension AddWorkVM: AddWorkVMProtocol {
    func didSave(model: WorkModel) {
        saveWorkModel(model: model)
        delegate?.showSuccesAlert()
    }

}
