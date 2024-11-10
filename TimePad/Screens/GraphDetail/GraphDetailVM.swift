//
//  GraphDetailVM.swift
//  TimePad
//
//  Created by Melik Demiray on 8.11.2024.
//

import Foundation

protocol GraphDetailVMProtocol {
    var delegate: GraphDetailVMDelegate? { get set }

}

protocol GraphDetailVMDelegate: AnyObject {
    func updateCollectionView()
}

final class GraphDetailVM {

    weak var delegate: GraphDetailVMDelegate?
    private let coreDataManager = CoreDataManager.shared
    private var workModels: [WorkModel] = []


}

extension GraphDetailVM: GraphDetailVMProtocol {

}
