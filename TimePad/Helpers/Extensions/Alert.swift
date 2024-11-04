//
//  Alert.swift
//  TimePad
//
//  Created by Melik Demiray on 26.09.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // are you sure alert
    func showAreYouSureAlert(title: String, message: String, actionTitle: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { _ in
            completion()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
