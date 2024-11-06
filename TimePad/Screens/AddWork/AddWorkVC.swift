//
//  AddWorkVC.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import UIKit

final class AddWorkVC: UIViewController, UITextFieldDelegate {

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
        addGestureToImages()
        setAccessibilityIdentifiers()
        workTitleText.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //configureTimePicker()
    }

    //MARK: Configure
    // MARK: - Search Method
    @objc func textFieldShouldReturn(_ workTitleText: UITextField) -> Bool
       {
           workTitleText.resignFirstResponder()
           return true
       }

    private func addGestureToImages() {
        for image in [workoutImage, workImage, readingImage, codingImage] {
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            image?.isUserInteractionEnabled = true
            image?.addGestureRecognizer(tap)
            image?.layer.cornerRadius = 10
        }
    }

    private func configureTimePicker() {
        // set time to 1 hour
        let calendar = Calendar.current
        if let defaultDate = calendar.date(bySettingHour: 0, minute: 5, second: 0, of: Date()) {
            timePicker.date = defaultDate
        }
    }

    private func setAccessibilityIdentifiers() {
        workoutImage.accessibilityIdentifier = "workoutImage"
        workImage.accessibilityIdentifier = "workImage"
        readingImage.accessibilityIdentifier = "readingImage"
        codingImage.accessibilityIdentifier = "codingImage"
        workTitleText.accessibilityIdentifier = "workTitleText"
        timePicker.accessibilityIdentifier = "timePicker"
        view.accessibilityIdentifier = "addWorkView"
    }

    //MARK: Handling Image Status
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

    //MARK: Actions
    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        switch sender.view {
        case workoutImage:
            handleImageSelection(for: ConstantsAddWork.workout, selectedImage: workoutImage)
        case workImage:
            handleImageSelection(for: ConstantsAddWork.work, selectedImage: workImage)
        case readingImage:
            handleImageSelection(for: ConstantsAddWork.reading, selectedImage: readingImage)
        case codingImage:
            handleImageSelection(for: ConstantsAddWork.coding, selectedImage: codingImage)
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
        returnImageToOriginalState()
    }
}

extension AddWorkVC: AddWorkVMDelegate {
    func clearTextField() {
        workTitleText.text = ""
    }

    func showSelectTypeAlert() {
        self.showAlert(title: ConstantsAddWork.errorTitle, message: ConstantsAddWork.selectTypeErrorMessage, actionTitle: ConstantsAddWork.ok)
    }

    func showSuccesAlert() {
        self.showAlert(title: ConstantsAddWork.successTitle, message: ConstantsAddWork.successMessage, actionTitle: ConstantsAddWork.ok)
    }

    func showErrorAlert() {
        self.showAlert(title: ConstantsAddWork.errorTitle, message: ConstantsAddWork.errorMessage, actionTitle: ConstantsAddWork.ok)
    }
}

private enum ConstantsAddWork {
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
