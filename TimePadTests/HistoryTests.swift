//
//  HistoryTest.swift
//  TimePadTests
//
//  Created by Melik Demiray on 4.11.2024.
//

import Testing
@testable import TimePad

struct HistoryTest {

    @Test
    func testDidFetchHistoryModels_WhenHistoryModelsNotEmpty_ShouldReloadTableView() {
        let viewModel = HistoryVM()
        let mockDelegate = MockHistoryVMDelegate()
        viewModel.delegate = mockDelegate
        let historyModels = [WorkModel(title: "Test Task", hour: 1, minute: 30, seconds: 0, type: "Work")]
        viewModel.getHistoryModels = historyModels

        viewModel.didFetchHistoryModels()

        #expect(mockDelegate.isReloadTableViewCalled)
    }

    @Test
    func testDidFetchHistoryModels_WhenHistoryModelsEmpty_ShouldShowEmptyLabel() {
        let viewModel = HistoryVM()
        let mockDelegate = MockHistoryVMDelegate()
        viewModel.delegate = mockDelegate
        let historyModels: [WorkModel] = []
        viewModel.getHistoryModels = historyModels

        viewModel.didFetchHistoryModels()

        #expect(mockDelegate.isEmptyLabelHidden)
    }

}

class MockHistoryVMDelegate: HistoryVMDelegate {
    func updateTableView() {
        reloadTableView()
    }
    
    func showEmptyView() {
        showEmptyLabel()
    }
    
    func hideEmptyView() {
        hideEmptyLabel()
    }
    
    var isReloadTableViewCalled = false
    var isEmptyLabelHidden = false

    func reloadTableView() {
        isReloadTableViewCalled = true
    }

    func showEmptyLabel() {
        isEmptyLabelHidden = false
    }

    func hideEmptyLabel() {
        isEmptyLabelHidden = true
    }
}
