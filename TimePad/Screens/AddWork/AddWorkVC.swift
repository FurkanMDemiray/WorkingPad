//
//  AddWorkVC.swift
//  TimePad
//
//  Created by Melik Demiray on 25.09.2024.
//

import UIKit

final class AddWorkVC: UIViewController {

    var viewModel: AddWorkVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    @IBOutlet private weak var workoutImage: UIImageView!
    @IBOutlet private weak var workImage: UIImageView!
    @IBOutlet private weak var readingImage: UIImageView!
    @IBOutlet private weak var codingImage: UIImageView!
    @IBOutlet private weak var workTitleText: UITextField!
    @IBOutlet private weak var timePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    private func addGestureToImages() {
        for image in [workoutImage, workImage, readingImage, codingImage] {
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            image?.isUserInteractionEnabled = true
            image?.addGestureRecognizer(tap)
        }
    }

    @objc private func imageTapped(sender: UITapGestureRecognizer) {

        
    }

}

extension AddWorkVC: AddWorkVMDelegate {
    func showAlert() {
        self.showAlert(title: "Error", message: "Please fill the title field", actionTitle: "OK")
    }


}
