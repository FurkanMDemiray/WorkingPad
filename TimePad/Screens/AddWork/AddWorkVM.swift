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

}

protocol AddWorkVMDelegate: AnyObject {
    func showAlert()
}

final class AddWorkVM {
    weak var delegate: AddWorkVMDelegate?
    

    private func saveWorkModel(model: WorkModel) {

    }


}

extension AddWorkVM: AddWorkVMProtocol {

}
