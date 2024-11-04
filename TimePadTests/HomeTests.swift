//
//  HomeTests.swift
//  TimePadTests
//
//  Created by Melik Demiray on 4.11.2024.
//

import Testing
@testable import TimePad

struct HomeTests {

    @Test
    func testDidFetchHomeModels_WhenHomeModelsNotEmpty_ShouldReloadTableView() {
        let viewModel = HomeVM()
        let mockDelegate = MockHomeVMDelegate()
        viewModel.delegate = mockDelegate
        let homeModels = [WorkModel(title: "Test Task", hour: 1, minute: 30, seconds: 0, type: "Work")]
        viewModel.getWorkModels = homeModels

        viewModel.didFetchWorkModels()

        #expect(mockDelegate.isReloadTableViewCalled)
    }

    @Test
    func testDidFetchHomeModels_WhenHomeModelsEmpty_ShouldShowEmptyLabel() {
        let viewModel = HomeVM()
        let mockDelegate = MockHomeVMDelegate()
        viewModel.delegate = mockDelegate
        let workModels: [WorkModel] = []
        viewModel.getWorkModels = workModels

        viewModel.didFetchWorkModels()

        #expect(mockDelegate.isEmptyLabelHidden)
    }
}

class MockHomeVMDelegate: HomeVMDelegate {
    func updateTimerCard() {
        updateTimerCardCalled()
    }

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
    var isUpdateTimerCardCalled = false

    func reloadTableView() {
        isReloadTableViewCalled = true
    }

    func showEmptyLabel() {
        isEmptyLabelHidden = false
    }

    func hideEmptyLabel() {
        isEmptyLabelHidden = true
    }

    func updateTimerCardCalled() {
        isUpdateTimerCardCalled = true
    }

}
