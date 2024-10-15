//
//  AddWorkVC.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import UIKit

final class AddWorkVC: UIViewController {

    @IBOutlet private weak var workoutImage: UIImageView!
    @IBOutlet private weak var workImage: UIImageView!
    @IBOutlet private weak var readingImage: UIImageView!
    @IBOutlet private weak var codingImage: UIImageView!
    @IBOutlet private weak var workTitleText: UITextField!
    @IBOutlet private weak var timePicker: UIDatePicker!

    var viewModel: AddWorkVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        viewModel.fetchWorkModels()
        addGestureToImages()
    }

    private func addGestureToImages() {
        for image in [workoutImage, workImage, readingImage, codingImage] {
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            image?.isUserInteractionEnabled = true
            image?.addGestureRecognizer(tap)
            image?.layer.cornerRadius = 10
        }
    }

    private func deselectOtherImages(image: UIImageView) {
        // clear other images except the selected one
        for img in [workoutImage, workImage, readingImage, codingImage] {
            if img != image {
                UIView.animate(withDuration: 0.2) {
                    img?.isHidden = true
                }
            }
        }
    }

    private func returnImageToOriginalState() {
        for img in [workoutImage, workImage, readingImage, codingImage] {
            UIView.animate(withDuration: 0.2) {
                img?.isHidden = false
            }
        }
    }

    private func handleImageSelection(for type: String, selectedImage: UIImageView) {
        if viewModel.getIsTypeSelected {
            returnImageToOriginalState()
            viewModel.getSelectedType = nil
            viewModel.getIsTypeSelected = false
        } else {
            deselectOtherImages(image: selectedImage)
            viewModel.getSelectedType = type
            viewModel.getIsTypeSelected = true
        }
    }

    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        switch sender.view {
        case workoutImage:
            handleImageSelection(for: Constants.workout, selectedImage: workoutImage)
        case workImage:
            handleImageSelection(for: Constants.work, selectedImage: workImage)
        case readingImage:
            handleImageSelection(for: Constants.reading, selectedImage: readingImage)
        case codingImage:
            handleImageSelection(for: Constants.coding, selectedImage: codingImage)
        default:
            print("default")
        }
    }

    @IBAction private func saveButtonClicked(_ sender: Any) {
        let hour = Calendar.current.component(.hour, from: timePicker.date)
        let minute = Calendar.current.component(.minute, from: timePicker.date)
        let type = viewModel.getSelectedType
        let model = WorkModel(title: workTitleText.text ?? "", hour: hour, minute: minute, type: type)
        viewModel.didSave(model: model)
    }
}

extension AddWorkVC: AddWorkVMDelegate {


    func showSelectTypeAlert() {
        self.showAlert(title: Constants.errorTitle, message: Constants.selectTypeErrorMessage, actionTitle: Constants.ok)
    }

    func showSuccesAlert() {
        self.showAlert(title: Constants.successTitle, message: Constants.successMessage, actionTitle: Constants.ok)
    }

    func showErrorAlert() {
        self.showAlert(title: Constants.errorTitle, message: Constants.errorMessage, actionTitle: Constants.ok)
    }
}

private enum Constants {
    static let workout = "Workout"
    static let work = "Work"
    static let reading = "Reading"
    static let coding = "Coding"
    static let successTitle = "Success"
    static let errorTitle = "Error"
    static let ok = "OK"
    static let successMessage = "Work added successfully"
    static let errorMessage = "Please fill the title field"
    static let selectTypeErrorMessage = "Please select a type"
}
