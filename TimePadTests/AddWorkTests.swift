//
//  TimePadTests.swift
//  TimePadTests
//
//  Created by Melik Demiray on 24.09.2024.
//

import Testing
@testable import TimePad

@Suite struct AddWorkVMTests {

    @Test
    func testDidSave_WhenTypeNotSelected_ShouldShowSelectTypeAlert() {
        let viewModel = AddWorkVM()
        let mockDelegate = MockAddWorkVMDelegate()
        viewModel.delegate = mockDelegate
        let workModel = WorkModel(title: "Test Task", hour: 1, minute: 30, type: nil)

        viewModel.didSave(model: workModel)

        #expect(mockDelegate.isShowSelectTypeAlertCalled)
    }

    @Test
    func testDidSave_WhenTitleIsEmpty_ShouldShowErrorAlert() {
        let viewModel = AddWorkVM()
        let mockDelegate = MockAddWorkVMDelegate()
        viewModel.delegate = mockDelegate
        viewModel.getSelectedType = "Work"
        let workModel = WorkModel(title: "", hour: 1, minute: 30, type: viewModel.getSelectedType)

        viewModel.didSave(model: workModel)

        #expect(mockDelegate.isShowErrorAlertCalled)
    }

    @Test
    func testDidSave_WhenTitleAndTypeAreValid_ShouldSaveModelAndShowSuccessAlert() {
        let viewModel = AddWorkVM()
        let mockDelegate = MockAddWorkVMDelegate()
        viewModel.delegate = mockDelegate
        viewModel.getSelectedType = "Work"
        let workModel = WorkModel(title: "Test Task", hour: 1, minute: 30, type: viewModel.getSelectedType)

        viewModel.didSave(model: workModel)

        #expect(mockDelegate.isClearTextFieldCalled)
        #expect(mockDelegate.isShowSuccessAlertCalled)
    }
}

class MockAddWorkVMDelegate: AddWorkVMDelegate {
    var isShowErrorAlertCalled = false
    var isShowSuccessAlertCalled = false
    var isShowSelectTypeAlertCalled = false
    var isClearTextFieldCalled = false

    func showErrorAlert() {
        isShowErrorAlertCalled = true
    }

    func showSuccesAlert() {
        isShowSuccessAlertCalled = true
    }

    func showSelectTypeAlert() {
        isShowSelectTypeAlertCalled = true
    }

    func clearTextField() {
        isClearTextFieldCalled = true
    }
}
