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
    var getSelectedType: String? { get set }
    var getIsTypeSelected: Bool { get set }

    func didSave(model: WorkModel)
    func fetchWorkModels()
}

protocol AddWorkVMDelegate: AnyObject {
    func showErrorAlert()
    func showSuccesAlert()
    func showSelectTypeAlert()
}

final class AddWorkVM {
    weak var delegate: AddWorkVMDelegate?
    let coreDataManager = CoreDataManager.shared

    private var selectedType: String?
    private var isTypeSelected: Bool = false

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
    var getIsTypeSelected: Bool {
        get {
            return isTypeSelected
        }
        set {
            isTypeSelected = newValue
        }
    }

    var getSelectedType: String? {
        get {
            return selectedType
        }
        set {
            selectedType = newValue
        }
    }

    func didSave(model: WorkModel) {
        if selectedType == nil {
            delegate?.showSelectTypeAlert()
            return
        }
        saveWorkModel(model: model)
        delegate?.showSuccesAlert()
    }

}
