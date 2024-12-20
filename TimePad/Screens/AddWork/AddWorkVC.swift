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
  @IBOutlet private weak var saveButton: UIButton!
  @IBOutlet private weak var codingLabel: UILabel!
  @IBOutlet private weak var readingLabel: UILabel!
  @IBOutlet private weak var workingLabel: UILabel!
  @IBOutlet private weak var trainingLabel: UILabel!

  var viewModel: AddWorkVMProtocol! {
    didSet {
      viewModel.delegate = self
    }
  }

  private var tutorialView: TutorialView?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    addGestureToImages()
    setAccessibilityIdentifiers()
    configureSaveButton()
    workTitleText.delegate = self

    // Check if tutorial should be shown (you might want to use UserDefaults to show it only once)
    if !UserDefaults.standard.bool(forKey: "hasSeenAddWorkTutorial") {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.showTutorial()
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  //MARK: Configure
  private func configureSaveButton() {
    saveButton.layer.cornerRadius = 10
    saveButton.tintColor = UIColor.hexStringToUIColor(hex: Colors.red)

  }

  private func addGestureToImages() {
    for image in [workoutImage, workImage, readingImage, codingImage] {
      let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
      image?.isUserInteractionEnabled = true
      image?.addGestureRecognizer(tap)
      image?.layer.cornerRadius = 10
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

    // clear other labels except the selected one
    for lbl in [codingLabel, readingLabel, workingLabel, trainingLabel] {
      if lbl != image {
        UIView.animate(withDuration: 0.2) {
          lbl?.isHidden = true
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

    for lbl in [codingLabel, readingLabel, workingLabel, trainingLabel] {
      UIView.animate(withDuration: 0.2) {
        lbl?.isHidden = false
      }
    }
  }

  private func handleImageSelection(
    for type: String, selectedImage: UIImageView, selectedLabel: UILabel
  ) {
    if viewModel.getIsTypeSelected {
      returnImageToOriginalState()
      viewModel.getSelectedType = nil
      viewModel.getIsTypeSelected = false
    } else {
      deselectOtherImages(image: selectedImage)
      viewModel.getSelectedType = type
      viewModel.getIsTypeSelected = true
    }
    selectedLabel.isHidden = false
  }

  //MARK: Actions
  @objc private func imageTapped(sender: UITapGestureRecognizer) {
    switch sender.view {
    case workoutImage:
      handleImageSelection(
        for: Constants.workout, selectedImage: workoutImage, selectedLabel: trainingLabel)
    case workImage:
      handleImageSelection(
        for: Constants.work, selectedImage: workImage, selectedLabel: workingLabel)
    case readingImage:
      handleImageSelection(
        for: Constants.reading, selectedImage: readingImage, selectedLabel: readingLabel)
    case codingImage:
      handleImageSelection(
        for: Constants.coding, selectedImage: codingImage, selectedLabel: codingLabel)
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

  private func showTutorial() {
    tutorialView = TutorialView(frame: view.bounds)
    guard let tutorialView = tutorialView else { return }

    view.addSubview(tutorialView)

    let steps: [(title: String, description: String, frame: CGRect)] = [
      (
        title: "Select Activity Type",
        description: "Choose the type of activity you want to track by tapping one of these icons",
        frame: CGRect(
          x: codingImage.frame.origin.x,
          y: codingImage.frame.origin.y,
          width: view.frame.width - 40,  // Approximate width to cover all images
          height: codingImage.frame.height)
      ),
      (
        title: "Add Title",
        description: "Give your activity a meaningful name",
        frame: workTitleText.frame
      ),
      (
        title: "Set Duration",
        description: "Select how long you want to work on this activity",
        frame: timePicker.frame
      ),
      (
        title: "Save Activity",
        description: "Tap here to save your activity and start tracking time",
        frame: saveButton.frame
      ),
    ]

    tutorialView.startTutorial(steps: steps) { [weak self] in
      UserDefaults.standard.set(true, forKey: "hasSeenAddWorkTutorial")
      self?.tutorialView?.removeFromSuperview()
      self?.tutorialView = nil
    }
  }
}

//MARK: - AddWorkVMDelegate
extension AddWorkVC: AddWorkVMDelegate {
  func clearTextField() {
    workTitleText.text = ""
  }

  func showSelectTypeAlert() {
    self.showAlert(
      title: ConstantsAddWork.errorTitle, message: ConstantsAddWork.selectTypeErrorMessage,
      actionTitle: ConstantsAddWork.ok)
  }

  func showSuccesAlert() {
    self.showAlert(
      title: ConstantsAddWork.successTitle, message: ConstantsAddWork.successMessage,
      actionTitle: ConstantsAddWork.ok)
  }

  func showErrorAlert() {
    self.showAlert(
      title: ConstantsAddWork.errorTitle, message: ConstantsAddWork.errorMessage,
      actionTitle: ConstantsAddWork.ok)
  }
}

extension AddWorkVC: UITextFieldDelegate {
  // MARK: - Search Method
  @objc func textFieldShouldReturn(_ workTitleText: UITextField) -> Bool {
    workTitleText.resignFirstResponder()
    return true
  }
}

private enum ConstantsAddWork {
  static let successTitle = "Success"
  static let errorTitle = "Error"
  static let ok = "OK"
  static let successMessage = "Work added successfully"
  static let errorMessage = "Please fill the title field"
  static let selectTypeErrorMessage = "Please select a type"
}
