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
}

protocol AddWorkVMDelegate: AnyObject {
    func showErrorAlert()
    func showSuccesAlert()
    func showSelectTypeAlert()
    func clearTextField()
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
        let id = UUID()
        coreDataManager
            .createWork(
            id: id.uuidString,
            title: title,
            hour: hour,
            minute: minute,
            seconds: 0,
            type: model.type ?? "Personal"
        )
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
        delegate?.clearTextField()
        delegate?.showSuccesAlert()
    }

}
