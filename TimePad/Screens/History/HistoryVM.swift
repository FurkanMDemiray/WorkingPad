//
//  HistoryVM.swift
//  TimePad
//
//  Created by Melik Demiray on 4.11.2024.
//

import Foundation

protocol HistoryVMProtocol {
  var delegate: HistoryVMDelegate? { get set }
  var getHistoryModels: [WorkModel] { get set }

  func didFetchHistoryModels()
  func deleteHistoryModel(at index: Int)
}

protocol HistoryVMDelegate: AnyObject {
  func updateTableView()
  func showEmptyView()
  func hideEmptyView()
}

final class HistoryVM {

  weak var delegate: HistoryVMDelegate?
  private let coreDataManager = CoreDataManager.shared
  private var historyModels: [WorkModel] = []

  private func fetchHistoryModels() {
    historyModels = coreDataManager.getWorkModels()
    historyModels = historyModels.filter { $0.hour == 0 && $0.minute == 0 && $0.seconds == 0 }
    historyModels.count == 0 ? delegate?.showEmptyView() : delegate?.hideEmptyView()
    delegate?.updateTableView()
  }
}
//MARK: - Protocol Functions
extension HistoryVM: HistoryVMProtocol {
  var getHistoryModels: [WorkModel] {
    get {
      historyModels
    }
    set {
      historyModels = newValue
    }
  }

  func didFetchHistoryModels() {
    fetchHistoryModels()
  }

  func deleteHistoryModel(at index: Int) {
    let work = coreDataManager.fetchWorks()[index]
    coreDataManager.deleteWork(work: work)
    coreDataManager.saveContext()
    fetchHistoryModels()
  }
}
