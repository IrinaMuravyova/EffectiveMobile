//
//  UIViewController + Extension.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
